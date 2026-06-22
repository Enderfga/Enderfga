#!/usr/bin/env python3
"""Crop a tall full-page browser capture (raw.png) down to its real content
height, writing homepage.png. The window is taller than the page so all
lazy-loaded media renders; this trims the trailing body-background area (and the
position:fixed back-to-top button that sits at the window bottom)."""
from PIL import Image

im = Image.open("raw.png").convert("RGB")
W, H = im.size
px = im.load()
bg = px[W // 2, H - 3]  # body background, sampled well below any content


def diff(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


last = H - 1
for y in range(H - 1, -1, -1):
    # ignore the bottom-right corner where the fixed button floats
    if any(diff(px[x, y], bg) > 24 for x in range(0, W, 5)
           if not (x > W - 200 and y > H - 200)):
        last = y
        break

im.crop((0, 0, W, last + 8)).save("homepage.png")
print(f"cropped {W}x{last + 8}")
