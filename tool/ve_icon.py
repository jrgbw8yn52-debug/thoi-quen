#!/usr/bin/env python3
"""AppIcon Habits. Nền #100e0c, người #f3ece4, vệt #e85d04, lửa #ffb020."""
from pathlib import Path

from PIL import Image, ImageDraw

BG = (16, 14, 12, 255)
FIG = (243, 236, 228, 255)
ACC = (232, 93, 4, 255)
LUA = (255, 176, 32, 255)
WHITE = (255, 255, 255, 255)


def capsule(draw, a, b, r, fill):
    draw.line([a, b], fill=fill, width=r * 2)
    draw.ellipse((a[0] - r, a[1] - r, a[0] + r, a[1] + r), fill=fill)
    draw.ellipse((b[0] - r, b[1] - r, b[0] + r, b[1] + r), fill=fill)


def ve(size: int, bg=BG, fig=FIG, acc=ACC, lua=LUA) -> Image.Image:
    im = Image.new("RGBA", (size, size), bg)
    d = ImageDraw.Draw(im)
    s = size / 1024

    def p(x, y):
        return (int(x * s), int(y * s))

    def r(n):
        return max(1, int(n * s))

    # lửa #ffb020
    flame = [
        p(210, 250),
        p(250, 170),
        p(300, 250),
        p(270, 340),
        p(230, 340),
    ]
    d.polygon(flame, fill=lua)
    d.ellipse((p(228, 250)[0], p(228, 250)[1], p(272, 330)[0], p(272, 330)[1]), fill=acc)

    # motion dashes
    for i, w in enumerate((18, 12, 8)):
        y = 430 + i * 55
        x0 = 90 + i * 20
        d.rounded_rectangle(
            (p(x0, y)[0], p(x0, y)[1], p(x0 + 70 + i * 10, y + w)[0], p(x0, y + w)[1] + r(w)),
            radius=r(w / 2),
            fill=acc,
        )

    # head
    hx, hy, hr = 560, 250, 78
    d.ellipse(
        (p(hx - hr, hy - hr)[0], p(hx - hr, hy - hr)[1], p(hx + hr, hy + hr)[0], p(hx + hr, hy + hr)[1]),
        fill=fig,
    )
    # torso lean
    capsule(d, p(520, 340), p(470, 560), r(52), fig)
    # back arm (up)
    capsule(d, p(500, 380), p(330, 300), r(28), fig)
    # front arm
    capsule(d, p(530, 400), p(760, 470), r(28), fig)
    # back leg
    capsule(d, p(460, 560), p(250, 780), r(34), fig)
    # front thigh
    capsule(d, p(490, 560), p(640, 700), r(34), fig)
    # front shin
    capsule(d, p(640, 700), p(560, 880), r(32), fig)
    return im


def pad_fg(src: Image.Image, out: int) -> Image.Image:
    """Adaptive foreground: figure in inner ~66% safe zone."""
    canvas = Image.new("RGBA", (out, out), (0, 0, 0, 0))
    inner = int(out * 0.72)
    fig = src.resize((inner, inner), Image.Resampling.LANCZOS)
    xy = (out - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def save_all():
    root = Path("/workspace/thoi_quen")
    master = ve(1024).convert("RGB")
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

    fg_src = ve(1024, bg=(0, 0, 0, 0))
    fg = pad_fg(fg_src, 432)
    drawable = android_res / "drawable"
    drawable.mkdir(parents=True, exist_ok=True)
    fg.save(drawable / "ic_launcher_foreground.png", "PNG")

    mono_src = ve(1024, bg=(0, 0, 0, 0), fig=WHITE, acc=WHITE, lua=WHITE)
    pad_fg(mono_src, 432).save(drawable / "ic_launcher_monochrome.png", "PNG")

    nhac = ve(192, bg=(0, 0, 0, 0), fig=WHITE, acc=WHITE, lua=WHITE)
    nhac.save(drawable / "ic_nhac.png", "PNG")

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
    print("ok", ios / "Icon-App-1024x1024@1x.png")


if __name__ == "__main__":
    save_all()
