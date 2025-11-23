import os
import shutil

CUSTOM_SVG_PATH = "{{ cookiecutter.custom_player_svg }}"

DEFAULT_PLAYER_SVG = """<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="108" height="108" fill="#478cbf" rx="20" ry="20" />
  <circle cx="64" cy="64" r="30" fill="white" />
  <circle cx="64" cy="64" r="10" fill="#478cbf" />
</svg>
"""

def main():
    player_svg_dest = os.path.join("assets", "player.svg")

    if CUSTOM_SVG_PATH and os.path.isfile(CUSTOM_SVG_PATH):
        # Copy the custom SVG file
        shutil.copy(CUSTOM_SVG_PATH, player_svg_dest)
        print(f"Copied custom player SVG from: {CUSTOM_SVG_PATH}")
    else:
        # Use the default SVG
        with open(player_svg_dest, "w") as f:
            f.write(DEFAULT_PLAYER_SVG)
        if CUSTOM_SVG_PATH:
            print(f"Warning: Custom SVG path not found: {CUSTOM_SVG_PATH}")
            print("Using default player SVG instead.")
        else:
            print("Using default player SVG.")

if __name__ == "__main__":
    main()
