#!/usr/bin/env python3
"""
Convert TOML-style color config (e.g. Alacritty theme) to Konsole .colorscheme format.

Usage:
    python toml_to_colorpalette.py input.toml [output.colorscheme] [--name ThemeName]
"""

import re
import sys
import argparse
from pathlib import Path


# Maps the 8 named normal colors to Color0–Color7 slots
COLOR_ORDER = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]


def hex_to_rgb(hex_color: str) -> tuple[int, int, int]:
    """Convert a #rrggbb hex string to an (r, g, b) tuple."""
    hex_color = hex_color.strip().lstrip("#")
    if len(hex_color) != 6:
        raise ValueError(f"Invalid hex color: #{hex_color}")
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return r, g, b


def rgb_str(hex_color: str) -> str:
    """Convert hex color to 'r,g,b' string."""
    r, g, b = hex_to_rgb(hex_color)
    return f"{r},{g},{b}"


def parse_toml_colors(text: str) -> dict:
    """
    Parse the TOML-style color config into a nested dict.
    Handles sections like [colors.normal] and key = "#hexval" entries.
    """
    colors = {}
    current_section = None

    for line in text.splitlines():
        line = line.strip()

        # Skip comments and empty lines
        if not line or line.startswith(";") or line.startswith("#"):
            continue

        # Section header: [colors.something]
        section_match = re.match(r'^\[colors\.(\w+)\]$', line)
        if section_match:
            current_section = section_match.group(1)
            colors.setdefault(current_section, {})
            continue

        # Key-value pair: key = "#hexvalue"
        kv_match = re.match(r'^(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"$', line)
        if kv_match and current_section:
            key = kv_match.group(1)
            value = kv_match.group(2)
            colors[current_section][key] = value

    return colors


def build_colorscheme(colors: dict, name: str) -> str:
    """Build the Konsole .colorscheme file content from parsed colors."""
    lines = []

    def section(header: str, comment: str = "", color_hex: str = ""):
        if comment:
            lines.append(f"; {comment}")
        lines.append(f"[{header}]")
        if color_hex:
            lines.append(f"Color={rgb_str(color_hex)}")
        lines.append("")

    # [General]
    lines.append("[General]")
    lines.append(f"Description={name}")
    lines.append("")

    # Background / Foreground
    bg = colors.get("primary", {}).get("background", "#000000")
    fg = colors.get("primary", {}).get("foreground", "#ffffff")

    lines.append("[Background]")
    lines.append(f"Color={rgb_str(bg)}")
    lines.append("")

    lines.append("[BackgroundIntense]")
    bright_black = colors.get("bright", {}).get("black", bg)
    lines.append(f"Color={rgb_str(bright_black)}")
    lines.append("")

    lines.append("[Foreground]")
    lines.append(f"Color={rgb_str(fg)}")
    lines.append("")

    lines.append("[ForegroundIntense]")
    bright_white = colors.get("bright", {}).get("white", fg)
    lines.append(f"Color={rgb_str(bright_white)}")
    lines.append("")

    # Color0–Color7 (normal) and Color0Intense–Color7Intense (bright)
    normal = colors.get("normal", {})
    bright = colors.get("bright", {})

    color_names = {
        "black":   "black",
        "red":     "red",
        "green":   "green",
        "yellow":  "yellow",
        "blue":    "blue",
        "magenta": "magenta / purple",
        "cyan":    "cyan",
        "white":   "white",
    }

    for i, color_key in enumerate(COLOR_ORDER):
        label = color_names[color_key]
        normal_hex = normal.get(color_key, "#000000")
        bright_hex = bright.get(color_key, normal_hex)

        lines.append(f"; {label}")
        lines.append(f"[Color{i}]")
        lines.append(f"Color={rgb_str(normal_hex)}")
        lines.append("")

        lines.append(f"[Color{i}Intense]")
        lines.append(f"Color={rgb_str(bright_hex)}")
        lines.append("")

    # Cursor (optional bonus section)
    cursor_text = colors.get("cursor", {}).get("text")
    cursor_color = colors.get("cursor", {}).get("cursor")
    if cursor_color:
        lines.append("; cursor")
        lines.append("[Cursor]")
        lines.append(f"Color={rgb_str(cursor_color)}")
        lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="Convert TOML color config to Konsole .colorscheme format"
    )
    parser.add_argument("input", help="Input TOML color file")
    parser.add_argument(
        "output", nargs="?", help="Output .colorscheme file (default: <input>.colorscheme)"
    )
    parser.add_argument(
        "--name", default=None, help="Theme name (default: stem of input filename)"
    )
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: input file '{input_path}' not found.", file=sys.stderr)
        sys.exit(1)

    output_path = Path(args.output) if args.output else input_path.with_suffix(".colorscheme")
    theme_name = args.name or input_path.stem.replace("_", " ").replace("-", " ").title()

    raw = input_path.read_text(encoding="utf-8")
    colors = parse_toml_colors(raw)

    if not colors:
        print("Error: no color sections found in input file.", file=sys.stderr)
        sys.exit(1)

    result = build_colorscheme(colors, theme_name)
    output_path.write_text(result, encoding="utf-8")

    print(f"Converted '{input_path}' → '{output_path}' (theme: {theme_name})")


if __name__ == "__main__":
    main()
