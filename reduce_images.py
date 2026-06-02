#!/usr/bin/env python3
"""Reduce image sizes in a directory (recursively).

Usage:
    python3 reduce_images.py --dir /path/to/dir --max-width 2048 --max-height 2048 --quality 85 --dry-run

Defaults are tuned for typical photo compression. The script overwrites files by default; use --out-dir to write reduced copies.
"""
import argparse
import os
from PIL import Image, ExifTags

SUPPORTED = ('.jpg', '.jpeg', '.png', '.tif', '.tiff', '.webp')


def process_image(path, out_path, max_w, max_h, quality, overwrite):
    try:
        with Image.open(path) as im:
            # Preserve orientation from EXIF
            try:
                for orientation in ExifTags.TAGS.keys():
                    if ExifTags.TAGS[orientation] == 'Orientation':
                        break
                exif = im._getexif()
                if exif is not None:
                    orient = exif.get(orientation)
                    if orient == 3:
                        im = im.rotate(180, expand=True)
                    elif orient == 6:
                        im = im.rotate(270, expand=True)
                    elif orient == 8:
                        im = im.rotate(90, expand=True)
            except Exception:
                pass

            orig_w, orig_h = im.size
            ratio = min(1.0, max_w / orig_w if max_w>0 else 1.0, max_h / orig_h if max_h>0 else 1.0)
            new_w = int(orig_w * ratio)
            new_h = int(orig_h * ratio)

            if ratio < 1.0:
                im = im.resize((new_w, new_h), Image.LANCZOS)

            os.makedirs(os.path.dirname(out_path), exist_ok=True)

            ext = os.path.splitext(out_path)[1].lower()
            save_kwargs = {}
            if ext in ('.jpg', '.jpeg'):
                save_kwargs['format'] = 'JPEG'
                save_kwargs['quality'] = quality
                save_kwargs['optimize'] = True
                save_kwargs['progressive'] = True
            elif ext == '.png':
                save_kwargs['format'] = 'PNG'
                if im.mode in ("RGBA", "LA"):
                    pass
                else:
                    im = im.convert('P', palette=Image.ADAPTIVE)
            elif ext == '.webp':
                save_kwargs['format'] = 'WEBP'
                save_kwargs['quality'] = quality

            im.save(out_path, **save_kwargs)
            return True, orig_w, orig_h, new_w, new_h
    except Exception as e:
        return False, str(e)


def find_images(root):
    for dirpath, dirnames, filenames in os.walk(root):
        for fn in filenames:
            if fn.lower().endswith(SUPPORTED):
                yield os.path.join(dirpath, fn)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', '-d', default=os.path.expanduser('~/Documents/AMENAGEMENT/Acclimo/Qfield/zh2/files'), help='Directory to process')
    parser.add_argument('--max-width', type=int, default=2048)
    parser.add_argument('--max-height', type=int, default=2048)
    parser.add_argument('--quality', type=int, default=85, help='JPEG/WEBP quality (0-100)')
    parser.add_argument('--out-dir', help='Write reduced images to this directory (keeps original structure). If omitted, files are overwritten')
    parser.add_argument('--dry-run', action='store_true', help="Don't write anything, just show what would change")
    args = parser.parse_args()

    root = os.path.expanduser(args.dir)
    out_base = os.path.expanduser(args.out_dir) if args.out_dir else None

    total = 0
    changed = 0
    skipped = 0
    errors = 0

    for path in find_images(root):
        total += 1
        rel = os.path.relpath(path, root)
        out_path = os.path.join(out_base, rel) if out_base else path

        if args.dry_run:
            print('DRY', path, '->', out_path)
            continue

        ok = False
        res = process_image(path, out_path, args.max_width, args.max_height, args.quality, out_base is None)
        if res[0] is True:
            changed += 1
            print('OK ', rel, f'{res[1]}x{res[2]} -> {res[3]}x{res[4]}')
        else:
            errors += 1
            print('ERR', rel, res[1])

    print(f"Processed {total} images: changed={changed}, errors={errors}, skipped={skipped}")


if __name__ == '__main__':
    main()
