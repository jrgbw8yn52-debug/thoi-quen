#!/usr/bin/env python3
"""Flat running-person app icon. Background #0c0d0b, figure #e7e4dc, accent #3d9a7a."""
from pathlib import Path

from PIL import Image, ImageDraw

BG = (12, 13, 11, 255)
FIG = (231, 228, 220, 255)
ACC = (61, 154, 122, 255)


def capsule(draw, a, b, r, fill):
    draw.line([a, b], fill=fill, width=r * 2)
    draw.ellipse((a[0] - r, a[1] - r, a[0] + r, a[1] + r), fill=fill)
    draw.ellipse((b[0] - r, b[1] - r, b[0] + r, b[1] + r), fill=fill)


def ve(size: int) -> Image.Image:
    im = Image.new("RGBA", (size, size), BG)
    d = ImageDraw.Draw(im)
    s = size / 1024

    def p(x, y):
        return (int(x * s), int(y * s))

    def r(n):
        return max(1, int(n * s))

    # motion dashes
    for i, w in enumerate((18, 12, 8)):
        y = 430 + i * 55
        x0 = 90 + i * 20
        d.rounded_rectangle(
            (p(x0, y)[0], p(x0, y)[1], p(x0 + 70 + i * 10, y + w)[0], p(x0, y + w)[1] + r(w)),
            radius=r(w / 2),
            fill=ACC,
        )

    # head
    hx, hy, hr = 560, 250, 78
    d.ellipse(
        (p(hx - hr, hy - hr)[0], p(hx - hr, hy - hr)[1], p(hx + hr, hy + hr)[0], p(hx + hr, hy + hr)[1]),
        fill=FIG,
    )
    # torso lean
    capsule(d, p(520, 340), p(470, 560), r(52), FIG)
    # back arm (up)
    capsule(d, p(500, 380), p(330, 300), r(28), FIG)
    # front arm
    capsule(d, p(530, 400), p(760, 470), r(28), FIG)
    # back leg
    capsule(d, p(460, 560), p(250, 780), r(34), FIG)
    # front thigh
    capsule(d, p(490, 560), p(640, 700), r(34), FIG)
    # front shin
    capsule(d, p(640, 700), p(560, 880), r(32), FIG)
    return im.convert("RGB")


def save_all():
    root = Path("/workspace/thoi_quen")
    master = ve(1024)
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
    android = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, px in android.items():
        dest = root / "android/app/src/main/res" / folder / "ic_launcher.png"
        dest.parent.mkdir(parents=True, exist_ok=True)
        master.resize((px, px), Image.Resampling.LANCZOS).save(dest, "PNG")
    print("ok", ios / "Icon-App-1024x1024@1x.png")


if __name__ == "__main__":
    save_all()
