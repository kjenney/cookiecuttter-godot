import os
import shutil

CUSTOM_PLAYER_SVG_PATH = "{{ cookiecutter.custom_player_svg }}"
INCLUDE_NPC = "{{ cookiecutter.include_npc }}"
CUSTOM_NPC_SVG_PATH = "{{ cookiecutter.custom_npc_svg }}"

DEFAULT_PLAYER_SVG = """<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="108" height="108" fill="#478cbf" rx="20" ry="20" />
  <circle cx="64" cy="64" r="30" fill="white" />
  <circle cx="64" cy="64" r="10" fill="#478cbf" />
</svg>
"""

DEFAULT_NPC_SVG = """<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="108" height="108" fill="#478cbf" rx="20" ry="20" />
  <circle cx="64" cy="64" r="30" fill="white" />
  <circle cx="64" cy="64" r="10" fill="#478cbf" />
</svg>
"""


def resolve_path(path):
    """
    Resolve a path that can be absolute or relative.
    Checks multiple locations for relative paths:
    1. Absolute path or path with ~ expansion
    2. Relative to parent directory (where cookiecutter was likely run)
    3. Relative to current directory
    """
    if not path:
        return None

    # Expand ~ to user home directory
    expanded_path = os.path.expanduser(path)

    # Check if it's an absolute path that exists
    if os.path.isabs(expanded_path) and os.path.isfile(expanded_path):
        return expanded_path

    # Check relative to parent directory (where cookiecutter was run)
    parent_relative = os.path.join("..", expanded_path)
    if os.path.isfile(parent_relative):
        return os.path.abspath(parent_relative)

    # Check relative to current directory
    if os.path.isfile(expanded_path):
        return os.path.abspath(expanded_path)

    # Check absolute path even if it doesn't exist yet (for error reporting)
    if os.path.isabs(expanded_path):
        return expanded_path

    # Return the parent-relative path for error reporting
    return os.path.abspath(parent_relative)


def setup_player_svg():
    player_svg_dest = os.path.join("assets", "player.svg")
    resolved_path = resolve_path(CUSTOM_PLAYER_SVG_PATH)

    if resolved_path and os.path.isfile(resolved_path):
        shutil.copy(resolved_path, player_svg_dest)
        print(f"Copied custom player SVG from: {resolved_path}")
    else:
        with open(player_svg_dest, "w") as f:
            f.write(DEFAULT_PLAYER_SVG)
        if CUSTOM_PLAYER_SVG_PATH:
            print(f"Warning: Custom player SVG path not found: {CUSTOM_PLAYER_SVG_PATH}")
            print("Using default player SVG instead.")
        else:
            print("Using default player SVG.")


def setup_npc():
    if INCLUDE_NPC.lower() != "yes":
        # Remove NPC files if not included
        npc_files = [
            os.path.join("scenes", "npc.tscn"),
            os.path.join("scripts", "npc.gd"),
            os.path.join("assets", "npc.svg"),
            os.path.join("tests", "test_npc.gd"),
        ]
        for filepath in npc_files:
            if os.path.exists(filepath):
                os.remove(filepath)
                print(f"Removed {filepath} (NPC not included)")
        return

    # Setup NPC SVG
    npc_svg_dest = os.path.join("assets", "npc.svg")
    resolved_path = resolve_path(CUSTOM_NPC_SVG_PATH)

    if resolved_path and os.path.isfile(resolved_path):
        shutil.copy(resolved_path, npc_svg_dest)
        print(f"Copied custom NPC SVG from: {resolved_path}")
    else:
        # Use player SVG as default for NPC if no custom NPC SVG provided
        player_svg_path = os.path.join("assets", "player.svg")
        if os.path.exists(player_svg_path):
            shutil.copy(player_svg_path, npc_svg_dest)
            print("Using player SVG as NPC SVG (default).")
        else:
            with open(npc_svg_dest, "w") as f:
                f.write(DEFAULT_NPC_SVG)
            print("Using default NPC SVG.")

        if CUSTOM_NPC_SVG_PATH:
            print(f"Warning: Custom NPC SVG path not found: {CUSTOM_NPC_SVG_PATH}")


def main():
    setup_player_svg()
    setup_npc()


if __name__ == "__main__":
    main()
