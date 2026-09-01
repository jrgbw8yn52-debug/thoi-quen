#!/usr/bin/env python3
"""Icon/splash từ ảnh đính — không vẽ lại mark. Nền #0D0D0D."""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageFilter

BG = (13, 13, 13, 255)  # #0D0D0D
SRC = Path("/workspace/attachments/619D66D3-3006-4AF5-A15C-3910A26B626F")
ROOT = Path("/workspace/thoi_quen")


def extract_mark(src: Image.Image) -> Image.Image:
    """Giữ pixel mark (cam/vàng + viền) từ ảnh; còn lại trong suốt."""
    rgba = src.convert("RGBA")
    px = rgba.load()
    w, h = rgba.size
    mask = Image.new("L", (w, h), 0)
    m = mask.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            # Chỉ vệt cam/vàng của mark, không lấy quầng mockup.
            if r > 140 and r >= b + 18 and g > 28:
                m[x, y] = 255
    mask = mask.filter(ImageFilter.MaxFilter(7)).filter(ImageFilter.GaussianBlur(0.6))
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    out.paste(rgba, (0, 0))
    out.putalpha(mask)
    box = out.getbbox()
    if box is None:
        raise SystemExit("no mark")
    return out.crop(box)


def fit_square(mark: Image.Image, inner: int) -> Image.Image:
    """Giữ tỉ lệ, fit vào inner×inner, trong suốt."""
    w, h = mark.size
    scale = inner / max(w, h)
    nw, nh = max(1, int(round(w * scale))), max(1, int(round(h * scale)))
    fig = mark.resize((nw, nh), Image.Resampling.LANCZOS)
    box = Image.new("RGBA", (inner, inner), (0, 0, 0, 0))
    box.paste(fig, ((inner - nw) // 2, (inner - nh) // 2), fig)
    return box


def square_on_bg(mark: Image.Image, size: int, *, pad_ratio: float = 0.18) -> Image.Image:
    """Mark giữa canvas size×size, nền #0D0D0D. pad_ratio = lề mỗi bên."""
    canvas = Image.new("RGB", (size, size), BG[:3])
    inner = max(1, int(round(size * (1 - 2 * pad_ratio))))
    fig = fit_square(mark, inner)
    xy = (size - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def fg_adaptive(mark: Image.Image, out: int = 432) -> Image.Image:
    """Foreground adaptive: trong suốt, mark trong safe zone ~66%."""
    canvas = Image.new("RGBA", (out, out), (0, 0, 0, 0))
    inner = int(out * 0.66)
    fig = fit_square(mark, inner)
    xy = (out - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def mono_mark(mark: Image.Image) -> Image.Image:
    """Monochrome / notification: alpha của mark, pixel trắng."""
    a = mark.split()[-1]
    out = Image.new("RGBA", mark.size, (0, 0, 0, 0))
    white = Image.new("RGBA", mark.size, (255, 255, 255, 255))
    out.paste(white, (0, 0), a)
    return out


def save_all():
    src = Image.open(SRC).convert("RGBA")
    mark = extract_mark(src)
    (ROOT / "tool").mkdir(exist_ok=True)
    mark.save(ROOT / "tool/mark_extracted.png", "PNG")

    master = square_on_bg(mark, 1024, pad_ratio=0.12)
    master.save(ROOT / "tool/preview_icon.png", "PNG")

    assets = ROOT / "assets"
    assets.mkdir(exist_ok=True)
    # Splash Flutter: mark trong suốt, Home vẽ nền #0D0D0D.
    splash_mark = fit_square(mark, 512)
    splash_mark.save(assets / "habis_mark.png", "PNG")
    square_on_bg(mark, 1024, pad_ratio=0.12).save(assets / "habis_icon.png", "PNG")

    ios = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
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
        square_on_bg(mark, px, pad_ratio=0.12).save(ios / name, "PNG")

    android_res = ROOT / "android/app/src/main/res"
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
        im = square_on_bg(mark, px, pad_ratio=0.12)
        im.save(dest_dir / "ic_launcher.png", "PNG")
        im.save(dest_dir / "ic_launcher_round.png", "PNG")

    drawable = android_res / "drawable"
    drawable.mkdir(parents=True, exist_ok=True)
    fg_adaptive(mark, 432).save(drawable / "ic_launcher_foreground.png", "PNG")
    fg_adaptive(mono_mark(mark), 432).save(drawable / "ic_launcher_monochrome.png", "PNG")

    nhac = fit_square(mono_mark(mark), 192)
    nhac.save(drawable / "ic_nhac.png", "PNG")

    splash = fit_square(mark, 256)
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

    mac_dir = ROOT / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    mac_dir.mkdir(parents=True, exist_ok=True)
    for name, px in {
        "app_icon_16.png": 16,
        "app_icon_32.png": 32,
        "app_icon_64.png": 64,
        "app_icon_128.png": 128,
        "app_icon_256.png": 256,
        "app_icon_512.png": 512,
        "app_icon_1024.png": 1024,
    }.items():
        square_on_bg(mark, px, pad_ratio=0.12).save(mac_dir / name, "PNG")

    launch_dir = ROOT / "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    launch_dir.mkdir(parents=True, exist_ok=True)
    for name, px, mpx in (
        ("LaunchImage.png", 168, 96),
        ("LaunchImage@2x.png", 336, 192),
        ("LaunchImage@3x.png", 504, 288),
    ):
        canvas = Image.new("RGB", (px, px), BG[:3])
        m = fit_square(mark, mpx)
        xy = (px - mpx) // 2
        canvas.paste(m, (xy, xy), m)
        canvas.save(launch_dir / name, "PNG")

    print("ok", ios / "Icon-App-1024x1024@1x.png", "mark", mark.size)


if __name__ == "__main__":
    save_all()
