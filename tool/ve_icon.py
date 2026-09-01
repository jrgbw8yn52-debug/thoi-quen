#!/usr/bin/env python3
"""HABIS AppIcon: 2 thanh chéo gradient #FF7A00→#FFB000, chấm cam trái dưới, nền #0D0D0D."""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

BG = (13, 13, 13, 255)
CAM = (255, 122, 0, 255)  # #FF7A00
VANG = (255, 176, 0, 255)  # #FFB000
WHITE = (255, 255, 255, 255)


def lerp(a, b, t: float):
    t = max(0.0, min(1.0, t))
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(len(a)))


def capsule_gradient(im: Image.Image, p0, p1, radius: float, c0, c1):
    """Vẽ capsule gradient dọc trục p0 (cam) → p1 (vàng)."""
    draw = ImageDraw.Draw(im)
    x0, y0 = p0
    x1, y1 = p1
    length = math.hypot(x1 - x0, y1 - y0)
    steps = max(8, int(length * 1.4))
    r = max(1, int(round(radius)))
    for i in range(steps + 1):
        t = i / steps
        x = x0 + (x1 - x0) * t
        y = y0 + (y1 - y0) * t
        col = lerp(c0, c1, t)
        draw.ellipse((x - r, y - r, x + r, y + r), fill=col)


def ve_mark(size: int, *, bg, cam=CAM, vang=VANG, cham=CAM) -> Image.Image:
    """Mark 2 thanh chéo + chấm trái dưới, canvas size×size."""
    im = Image.new("RGBA", (size, size), bg)
    s = size / 1024.0

    def p(x, y):
        return (x * s, y * s)

    # Góc ~38° so với thẳng đứng, đỉnh lệch phải.
    theta = math.radians(38)
    dx, dy = -math.sin(theta), math.cos(theta)  # từ đỉnh → đáy: trái + xuống
    length = 430 * s
    radius = 56 * s
    gap = 132 * s

    # Tâm cụm hơi lệch phải-trên để chấm cân trái dưới.
    cx, cy = 530 * s, 470 * s
    px, py = dy, -dx  # pháp tuyến (sang phải của hướng đáy)

    def bar(cx_, cy_):
        half = length / 2
        top = (cx_ - dx * half, cy_ - dy * half)
        bot = (cx_ + dx * half, cy_ + dy * half)
        return bot, top  # cam ở đáy, vàng ở đỉnh

    left_c = (cx - px * gap / 2, cy - py * gap / 2)
    right_c = (cx + px * gap / 2, cy + py * gap / 2)
    # Thanh phải hạ thấp hơn một nhịp.
    right_c = (right_c[0] + dx * 36 * s, right_c[1] + dy * 36 * s)

    b0, t0 = bar(*left_c)
    b1, t1 = bar(*right_c)
    capsule_gradient(im, b0, t0, radius, cam, vang)
    capsule_gradient(im, b1, t1, radius, cam, vang)

    # Chấm cam: đáy thanh trái, lệch trái.
    dot_r = 78 * s
    dot_cx = b0[0] - 18 * s
    dot_cy = b0[1] + 8 * s
    d = ImageDraw.Draw(im)
    d.ellipse(
        (dot_cx - dot_r, dot_cy - dot_r, dot_cx + dot_r, dot_cy + dot_r),
        fill=cham,
    )
    return im


def rounded_app(src: Image.Image, radius_ratio=0.223) -> Image.Image:
    """Bo góc kiểu iOS cho preview, icon thật để OS mask."""
    w, h = src.size
    r = int(w * radius_ratio)
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w - 1, h - 1), radius=r, fill=255)
    out = src.convert("RGBA")
    out.putalpha(mask)
    return out


def pad_fg(src: Image.Image, out: int) -> Image.Image:
    canvas = Image.new("RGBA", (out, out), (0, 0, 0, 0))
    inner = int(out * 0.72)
    fig = src.resize((inner, inner), Image.Resampling.LANCZOS)
    xy = (out - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def save_all():
    root = Path("/workspace/thoi_quen")
    hi = ve_mark(2048, bg=BG).resize((1024, 1024), Image.Resampling.LANCZOS)
    master = hi.convert("RGB")

    preview = rounded_app(hi)
    (root / "tool").mkdir(exist_ok=True)
    preview.save(root / "tool/preview_icon.png", "PNG")

    ios = root / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    ios.mkdir(parents=True, exist_ok=True)
    sizes = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    for name, px in sizes.items():
        master.resize((px, px), Image.Resampling.LANCZOS).save(ios / name, "PNG")

    android_res = root / "android/app/src/main/res"
    legacy = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, px in legacy.items():
        dest_dir = android_res / folder
        dest_dir.mkdir(parents=True, exist_ok=True)
        im = master.resize((px, px), Image.Resampling.LANCZOS)
        im.save(dest_dir / "ic_launcher.png", "PNG")
        im.save(dest_dir / "ic_launcher_round.png", "PNG")

    fg_src = ve_mark(2048, bg=(0, 0, 0, 0)).resize((1024, 1024), Image.Resampling.LANCZOS)
    drawable = android_res / "drawable"
    drawable.mkdir(parents=True, exist_ok=True)
    pad_fg(fg_src, 432).save(drawable / "ic_launcher_foreground.png", "PNG")

    mono = ve_mark(2048, bg=(0, 0, 0, 0), cam=WHITE, vang=WHITE, cham=WHITE)
    pad_fg(mono.resize((1024, 1024), Image.Resampling.LANCZOS), 432).save(
        drawable / "ic_launcher_monochrome.png", "PNG"
    )

    nhac = ve_mark(384, bg=(0, 0, 0, 0), cam=WHITE, vang=WHITE, cham=WHITE)
    nhac.resize((192, 192), Image.Resampling.LANCZOS).save(drawable / "ic_nhac.png", "PNG")

    # Splash mark: trong suốt, ~256
    splash = ve_mark(1024, bg=(0, 0, 0, 0)).resize((256, 256), Image.Resampling.LANCZOS)
    splash.save(drawable / "splash_mark.png", "PNG")

    anydpi = android_res / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    adaptive = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
    <monochrome android:drawable="@drawable/ic_launcher_monochrome"/>
</adaptive-icon>
"""
    (anydpi / "ic_launcher.xml").write_text(adaptive)
    (anydpi / "ic_launcher_round.xml").write_text(adaptive)

    macos = {
        "app_icon_16.png": 16,
        "app_icon_32.png": 32,
        "app_icon_64.png": 64,
        "app_icon_128.png": 128,
        "app_icon_256.png": 256,
        "app_icon_512.png": 512,
        "app_icon_1024.png": 1024,
    }
    mac_dir = root / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    mac_dir.mkdir(parents=True, exist_ok=True)
    for name, px in macos.items():
        master.resize((px, px), Image.Resampling.LANCZOS).save(mac_dir / name, "PNG")

    # iOS launch image: mark trên nền #0D0D0D
    launch_dir = root / "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    launch_dir.mkdir(parents=True, exist_ok=True)
    for name, px, mark in (
        ("LaunchImage.png", 168, 96),
        ("LaunchImage@2x.png", 336, 192),
        ("LaunchImage@3x.png", 504, 288),
    ):
        canvas = Image.new("RGB", (px, px), BG[:3])
        m = ve_mark(mark * 2, bg=(0, 0, 0, 0)).resize((mark, mark), Image.Resampling.LANCZOS)
        xy = (px - mark) // 2
        canvas.paste(m, (xy, xy), m)
        canvas.save(launch_dir / name, "PNG")

    print("ok", ios / "Icon-App-1024x1024@1x.png")


if __name__ == "__main__":
    save_all()
