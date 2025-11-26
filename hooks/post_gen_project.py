import os
import shutil
import wave
import math
import struct

CUSTOM_PLAYER_SVGS = "{{ cookiecutter.custom_player_svgs }}"
PLAYER_TYPES = "{{ cookiecutter.player_types }}"
INCLUDE_NPC = "{{ cookiecutter.include_npc }}"
CUSTOM_NPC_SVG_PATH = "{{ cookiecutter.custom_npc_svg }}"
VICTORY_SOUND_PATH = "{{ cookiecutter.victory_sound }}"

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


def parse_player_svgs():
    """
    Parse the custom_player_svgs string into a dictionary.
    Format: "blue:/path/to/blue.svg,red:/path/to/red.svg,green:/path/to/green.svg"
    Returns: dict like {"blue": "/path/to/blue.svg", "red": "/path/to/red.svg"}
    """
    if not CUSTOM_PLAYER_SVGS:
        return {}

    player_svgs = {}
    for pair in CUSTOM_PLAYER_SVGS.split(","):
        pair = pair.strip()
        if ":" in pair:
            player_type, path = pair.split(":", 1)
            player_svgs[player_type.strip()] = path.strip()

    return player_svgs


def setup_player_svg():
    """
    Setup player SVG(s). Supports:
    1. custom_player_svgs - specific SVG for each player type
    2. Default SVG (if no custom_player_svgs provided)
    """
    player_types = [t.strip() for t in PLAYER_TYPES.split(",")]
    custom_svgs = parse_player_svgs()

    # Check if we have type-specific SVGs
    if custom_svgs:
        print("Using type-specific player SVGs...")
        for player_type in player_types:
            dest_path = os.path.join("assets", f"player_{player_type}.svg")

            if player_type in custom_svgs:
                resolved_path = resolve_path(custom_svgs[player_type])
                if resolved_path and os.path.isfile(resolved_path):
                    shutil.copy(resolved_path, dest_path)
                    print(f"  {player_type}: Copied from {resolved_path}")
                else:
                    # Use default if custom not found
                    with open(dest_path, "w") as f:
                        f.write(DEFAULT_PLAYER_SVG)
                    print(f"  {player_type}: Warning - path not found, using default")
            else:
                # No custom SVG specified for this type, use default
                with open(dest_path, "w") as f:
                    f.write(DEFAULT_PLAYER_SVG)
                print(f"  {player_type}: Using default SVG")
    else:
        # Use default for all types
        print("Using default player SVG for all types...")
        for player_type in player_types:
            dest_path = os.path.join("assets", f"player_{player_type}.svg")
            with open(dest_path, "w") as f:
                f.write(DEFAULT_PLAYER_SVG)
            print(f"  {player_type}: Created default SVG")


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


def generate_victory_sound(output_path, duration=0.6, sample_rate=44100):
    """
    Generate a simple victory sound (three ascending notes: C, E, G)
    """
    # Notes: C5 (523 Hz), E5 (659 Hz), G5 (784 Hz)
    notes = [523, 659, 784]
    note_duration = duration / len(notes)
    samples_per_note = int(sample_rate * note_duration)

    # Open WAV file
    with wave.open(output_path, 'w') as wav_file:
        # Set parameters: 1 channel (mono), 2 bytes per sample (16-bit), sample_rate
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)

        # Generate each note
        for freq in notes:
            for i in range(samples_per_note):
                # Generate sine wave with envelope (fade in/out)
                t = i / sample_rate
                envelope = min(i / (samples_per_note * 0.1),
                             (samples_per_note - i) / (samples_per_note * 0.2))
                envelope = min(envelope, 1.0)

                # Generate sine wave sample
                sample = int(32767 * 0.3 * envelope * math.sin(2 * math.pi * freq * t))
                # Pack as signed 16-bit integer
                wav_file.writeframes(struct.pack('<h', sample))

    print(f"Generated victory sound: {output_path}")


def setup_victory_sound():
    """
    Setup victory sound - use custom if provided, otherwise generate default
    """
    victory_sound_dest = os.path.join("assets", "victory.wav")
    resolved_path = resolve_path(VICTORY_SOUND_PATH)

    if resolved_path and os.path.isfile(resolved_path):
        shutil.copy(resolved_path, victory_sound_dest)
        print(f"Copied custom victory sound from: {resolved_path}")
    else:
        # Generate default victory sound
        generate_victory_sound(victory_sound_dest)
        if VICTORY_SOUND_PATH:
            print(f"Warning: Custom victory sound path not found: {VICTORY_SOUND_PATH}")
            print("Using generated victory sound instead.")


def main():
    setup_player_svg()
    setup_npc()
    setup_victory_sound()


if __name__ == "__main__":
    main()
