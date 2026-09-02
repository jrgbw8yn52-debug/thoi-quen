#!/usr/bin/env python3
"""Icon 55% lề ≥18% nền #0D0D0D · splash poster chữ nhật #000000 · mark đen widget."""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

BG_ICON = (13, 13, 13, 255)  # #0D0D0D launcher
BG_SPLASH = (0, 0, 0, 255)  # #000000 splash
MUC = (13, 13, 13, 255)  # #0D0D0D chữ/mark widget
CAM = (255, 122, 0, 255)  # #FF7A00
SRC = Path("/workspace/attachments/F26C7BBE-1827-49BD-8D38-A712108C056A")
ROOT = Path("/workspace/thoi_quen")
ADAPTIVE_INNER = 0.55  # không 66%
PAD_SQUARE = 0.18  # lề ≥18% mỗi phía


def extract_mark(src: Image.Image) -> Image.Image:
    """Giữ pixel mark cam; nền trong suốt. Không giãn, không xoay, không vẽ lại."""
    rgba = src.convert("RGBA")
    px = rgba.load()
    w, h = rgba.size
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    op = out.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if r > 55 and r >= b + 10 and r >= g and g > 12:
                op[x, y] = (r, g, b, 255)
    box = out.getbbox()
    if box is None:
        raise SystemExit("no mark")
    return out.crop(box)


def crush_poster(src: Image.Image) -> Image.Image:
    """Poster chữ nhật: mark cam, còn lại #000000. Cấm vệt sáng / divider JPEG."""
    rgba = src.convert("RGBA")
    px = rgba.load()
    w, h = rgba.size
    out = Image.new("RGB", (w, h), (0, 0, 0))
    op = out.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if r > 55 and r >= b + 10 and r >= g and g > 12:
                op[x, y] = (r, g, b)
    return out


def fit_square(mark: Image.Image, inner: int) -> Image.Image:
    w, h = mark.size
    scale = inner / max(w, h)
    nw, nh = max(1, int(round(w * scale))), max(1, int(round(h * scale)))
    fig = mark.resize((nw, nh), Image.Resampling.LANCZOS)
    box = Image.new("RGBA", (inner, inner), (0, 0, 0, 0))
    box.paste(fig, ((inner - nw) // 2, (inner - nh) // 2), fig)
    return box


def square_on_bg(
    mark: Image.Image,
    size: int,
    *,
    pad_ratio: float,
    bg: tuple[int, int, int, int],
) -> Image.Image:
    canvas = Image.new("RGB", (size, size), bg[:3])
    inner = max(1, int(round(size * (1 - 2 * pad_ratio))))
    fig = fit_square(mark, inner)
    xy = (size - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def fg_adaptive(mark: Image.Image, out: int = 432) -> Image.Image:
    """Foreground adaptive: mark ~55% cạnh, lề ~22.5% ≥ 18%. Căn giữa tuyệt đối."""
    canvas = Image.new("RGBA", (out, out), (0, 0, 0, 0))
    inner = int(round(out * ADAPTIVE_INNER))
    fig = fit_square(mark, inner)
    xy = (out - inner) // 2
    canvas.paste(fig, (xy, xy), fig)
    return canvas


def mono_mark(mark: Image.Image, fill: tuple[int, int, int, int] = (255, 255, 255, 255)) -> Image.Image:
    a = mark.split()[-1]
    out = Image.new("RGBA", mark.size, (0, 0, 0, 0))
    layer = Image.new("RGBA", mark.size, fill)
    out.paste(layer, (0, 0), a)
    return out


def contain_on_black(poster: Image.Image, w: int, h: int) -> Image.Image:
    canvas = Image.new("RGB", (w, h), (0, 0, 0))
    sw, sh = poster.size
    scale = min(w / sw, h / sh)
    nw, nh = max(1, int(round(sw * scale))), max(1, int(round(sh * scale)))
    fig = poster.resize((nw, nh), Image.Resampling.LANCZOS)
    canvas.paste(fig, ((w - nw) // 2, (h - nh) // 2))
    return canvas


def save_all():
    src = Image.open(SRC).convert("RGBA")
    mark = extract_mark(src)
    poster = crush_poster(src)
    (ROOT / "tool").mkdir(exist_ok=True)
    mark.save(ROOT / "tool/mark_extracted.png", "PNG")

    master = square_on_bg(mark, 1024, pad_ratio=PAD_SQUARE, bg=BG_ICON)
    master.save(ROOT / "tool/preview_icon.png", "PNG")

    assets = ROOT / "assets"
    assets.mkdir(exist_ok=True)
    splash_mark = fit_square(mark, 512)
    splash_mark.save(assets / "habis_mark.png", "PNG")
    square_on_bg(mark, 1024, pad_ratio=PAD_SQUARE, bg=BG_ICON).save(assets / "habis_icon.png", "PNG")
    contain_on_black(poster, 1000, 1500).save(assets / "habis_splash.png", "PNG")

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
        square_on_bg(mark, px, pad_ratio=PAD_SQUARE, bg=BG_ICON).save(ios / name, "PNG")

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
        im = square_on_bg(mark, px, pad_ratio=PAD_SQUARE, bg=BG_ICON)
        im.save(dest_dir / "ic_launcher.png", "PNG")
        im.save(dest_dir / "ic_launcher_round.png", "PNG")

    drawable = android_res / "drawable"
    drawable.mkdir(parents=True, exist_ok=True)
    fg_adaptive(mark, 432).save(drawable / "ic_launcher_foreground.png", "PNG")
    fg_adaptive(mono_mark(mark), 432).save(drawable / "ic_launcher_monochrome.png", "PNG")

    nhac = fit_square(mono_mark(mark), 192)
    nhac.save(drawable / "ic_nhac.png", "PNG")

    # Mark đen đảo từ logo — tỉ lệ thật, không nhét vuông 16–22dp.
    den = mono_mark(mark, MUC)
    dw, dh = den.size
    nh = 320
    nw = max(1, int(round(dw * nh / dh)))
    den_h = den.resize((nw, nh), Image.Resampling.LANCZOS)
    den_h.save(drawable / "widget_mark.png", "PNG")

    # Preview 4×2: trên/dưới trong suốt, dải cam 62% bo 20dp, chữ sát lửa.
    pw, ph = 750, 330
    prev = Image.new("RGBA", (pw, ph), (0, 0, 0, 0))
    band_h = int(round(ph * 0.62))
    band_y = (ph - band_h) // 2
    radius = int(round(20 * (ph / 110)))
    draw = ImageDraw.Draw(prev)
    draw.rounded_rectangle(
        [0, band_y, pw - 1, band_y + band_h - 1],
        radius=radius,
        fill=CAM,
    )
    mh = int(round(band_h * 0.78))
    mw = max(1, int(round(nw * mh / nh)))
    m = den_h.resize((mw, mh), Image.Resampling.LANCZOS)
    margin = int(round(12 * (ph / 110)))
    prev.paste(m, (margin, band_y + (band_h - mh) // 2), m)
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 42)
        font_s = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 34)
        font_k = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 38)
        font_n = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 72)
    except OSError:
        font = ImageFont.load_default()
        font_s = font
        font_k = font
        font_n = font
    flame_h = 84
    fx = pw - 200
    fy = band_y + (band_h - flame_h) // 2
    draw.polygon(
        [(fx + 28, fy), (fx + 8, fy + flame_h - 8), (fx + 48, fy + flame_h - 8)],
        fill=MUC[:3],
    )
    draw.text((fx + 56, fy + 8), "12", fill=MUC[:3], font=font_n)
    tx = fx - 16 - 280
    ty = band_y + band_h // 2 - 54
    draw.text((tx, ty), "Thứ Tư 2/9", fill=MUC[:3], font=font)
    draw.text((tx, ty + 48), "3/5 thói quen", fill=MUC[:3], font=font_s)
    draw.text((tx, ty + 88), "2250 / 2920 kcal", fill=MUC[:3], font=font_k)
    prev.save(drawable / "widget_preview.png", "PNG")

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
        square_on_bg(mark, px, pad_ratio=PAD_SQUARE, bg=BG_ICON).save(mac_dir / name, "PNG")

    launch_dir = ROOT / "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    launch_dir.mkdir(parents=True, exist_ok=True)
    contain_on_black(poster, 400, 600).save(launch_dir / "LaunchImage.png", "PNG")
    contain_on_black(poster, 800, 1200).save(launch_dir / "LaunchImage@2x.png", "PNG")
    contain_on_black(poster, 1200, 1800).save(launch_dir / "LaunchImage@3x.png", "PNG")

    print(
        "ok",
        "mark",
        mark.size,
        "adaptive_inner",
        ADAPTIVE_INNER,
        "pad",
        PAD_SQUARE,
        "fg",
        drawable / "ic_launcher_foreground.png",
    )


if __name__ == "__main__":
    save_all()
