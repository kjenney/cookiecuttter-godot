import os
import shutil
import wave
import math
import struct
import json

CUSTOM_PLAYER_SVGS = "{{ cookiecutter.custom_player_svgs }}"
PLAYER_TYPES = "{{ cookiecutter.player_types }}"
INCLUDE_NPC = "{{ cookiecutter.include_npc }}"
CUSTOM_NPC_SVG_PATH = "{{ cookiecutter.custom_npc_svg }}"
VICTORY_SOUND_PATH = "{{ cookiecutter.victory_sound }}"
LEVEL_COUNT = int("{{ cookiecutter.level_count }}")
LEVELS_CONFIG_PATH = "{{ cookiecutter.levels_config }}"

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


def load_levels_config():
    """
    Load levels configuration from JSON file or create default config
    """
    if LEVELS_CONFIG_PATH:
        resolved_path = resolve_path(LEVELS_CONFIG_PATH)
        if resolved_path and os.path.isfile(resolved_path):
            with open(resolved_path, 'r') as f:
                config = json.load(f)
                print(f"Loaded levels configuration from: {resolved_path}")
                return config['levels']
        else:
            print(f"Warning: Levels config not found: {LEVELS_CONFIG_PATH}")

    # Generate default levels configuration
    print(f"Generating default configuration for {LEVEL_COUNT} level(s)...")
    levels = []
    for i in range(LEVEL_COUNT):
        level_num = i + 1
        levels.append({
            "name": f"level_{level_num}",
            "npc": {
                "enabled": INCLUDE_NPC.lower() == "yes",
                "type": f"npc_{level_num}",
                "message": f"Welcome to Level {level_num}!",
                "svg": ""
            },
            "collectibles": 4 + (i * 2),  # Increase collectibles each level
            "target_score": 40 + (i * 20),  # Increase target each level
            "background_color": "#1a1a1a"
        })
    return levels


def generate_level_scene(level_config, level_index):
    """
    Generate a level scene file (.tscn) based on level configuration
    """
    level_name = level_config['name']
    npc_config = level_config.get('npc', {})
    collectibles_count = level_config.get('collectibles', 4)
    bg_color = level_config.get('background_color', '#1a1a1a')

    # Convert hex color to Godot Color format
    def hex_to_godot_color(hex_color):
        hex_color = hex_color.lstrip('#')
        r = int(hex_color[0:2], 16) / 255.0
        g = int(hex_color[2:4], 16) / 255.0
        b = int(hex_color[4:6], 16) / 255.0
        return f"Color({r:.3f}, {g:.3f}, {b:.3f}, 1)"

    godot_color = hex_to_godot_color(bg_color)
    has_npc = npc_config.get('enabled', False)
    npc_message = npc_config.get('message', 'Hi, how are you?')

    # Calculate load_steps - add 2 for level-specific NPC (texture + sub_resource) if NPC is enabled
    load_steps = 7 if has_npc else 4

    # Generate collectible positions in a grid pattern
    collectible_positions = []
    if collectibles_count > 0:
        # Arrange collectibles in a rough grid
        cols = min(collectibles_count, 4)
        rows = (collectibles_count + cols - 1) // cols

        for i in range(collectibles_count):
            row = i // cols
            col = i % cols
            x = 200 + (col * 250)
            y = 200 + (row * 150)
            collectible_positions.append((x, y))

    # Build the scene file content
    scene_content = f'''[gd_scene load_steps={load_steps} format=3 uid="uid://level_{level_index}_uid"]

[ext_resource type="PackedScene" uid="uid://b8j5k2x4y1z3" path="res://scenes/player.tscn" id="1_player"]
[ext_resource type="PackedScene" uid="uid://c9k6l3y5z2a4" path="res://scenes/collectible.tscn" id="2_collectible"]
[ext_resource type="Script" path="res://scripts/game_manager.gd" id="3_manager"]
'''

    if has_npc:
        scene_content += '[ext_resource type="PackedScene" uid="uid://npc1a2b3c4d5e" path="res://scenes/npc.tscn" id="4_npc"]\n'
        scene_content += f'[ext_resource type="Texture2D" path="res://assets/{level_name}_npc.svg" id="5_npc_texture"]\n'
        scene_content += '[ext_resource type="PackedScene" uid="uid://ui1a2b3c4d5e6" path="res://scenes/ui_layer.tscn" id="6_ui"]\n\n'
        # Add custom SpriteFrames sub-resource for level-specific NPC texture
        scene_content += '''[sub_resource type="SpriteFrames" id="SpriteFrames_NPC"]
animations = [{
"frames": [{
"duration": 1.0,
"texture": ExtResource("5_npc_texture")
}],
"loop": true,
"name": &"idle",
"speed": 5.0
}, {
"frames": [{
"duration": 1.0,
"texture": ExtResource("5_npc_texture")
}],
"loop": true,
"name": &"talking",
"speed": 8.0
}]

'''
    else:
        scene_content += '[ext_resource type="PackedScene" uid="uid://ui1a2b3c4d5e6" path="res://scenes/ui_layer.tscn" id="5_ui"]\n\n'

    scene_content += '''[node name="Main" type="Node2D"]
process_mode = 3
script = ExtResource("3_manager")

[node name="Background" type="ColorRect" parent="."]
offset_right = 1152.0
offset_bottom = 648.0
color = ''' + godot_color + '''

[node name="Player" parent="." instance=ExtResource("1_player")]
process_mode = 1
position = Vector2(576, 324)

'''

    # Add collectibles
    for i, (x, y) in enumerate(collectible_positions, 1):
        scene_content += f'''[node name="Collectible{i}" parent="." instance=ExtResource("2_collectible")]
position = Vector2({x}, {y})

'''

    # Add NPC if enabled
    if has_npc:
        scene_content += '''[node name="NPC" parent="." instance=ExtResource("4_npc")]
position = Vector2(576, 150)
npc_message = "''' + npc_message + '''"

[node name="AnimatedSprite2D" parent="NPC"]
sprite_frames = SubResource("SpriteFrames_NPC")

'''

    # Add UI layer - use correct ExtResource ID based on whether NPC is present
    ui_resource_id = "6_ui" if has_npc else "5_ui"
    scene_content += f'''[node name="UILayer" parent="." instance=ExtResource("{ui_resource_id}")]
process_mode = 1
'''

    return scene_content


def setup_levels(levels_config):
    """
    Setup level-specific assets (NPCs, etc.) based on configuration
    """
    print(f"Setting up {len(levels_config)} level(s)...")

    for i, level in enumerate(levels_config):
        level_name = level['name']
        npc_config = level.get('npc', {})

        # Setup NPC SVG if needed
        if npc_config.get('enabled', False):
            npc_type = npc_config.get('type', 'npc')
            npc_svg_path = npc_config.get('svg', '')
            dest_path = os.path.join("assets", f"{level_name}_npc.svg")

            if npc_svg_path:
                resolved_path = resolve_path(npc_svg_path)
                if resolved_path and os.path.isfile(resolved_path):
                    shutil.copy(resolved_path, dest_path)
                    print(f"  {level_name}: Copied NPC SVG from {resolved_path}")
                else:
                    # Use default NPC SVG
                    with open(dest_path, "w") as f:
                        f.write(DEFAULT_NPC_SVG)
                    print(f"  {level_name}: Using default NPC SVG")
            else:
                # Use default NPC SVG
                with open(dest_path, "w") as f:
                    f.write(DEFAULT_NPC_SVG)
                print(f"  {level_name}: Created default NPC SVG")

        # Generate level scene file
        scene_content = generate_level_scene(level, i + 1)
        scene_path = os.path.join("scenes", f"{level_name}.tscn")
        with open(scene_path, 'w') as f:
            f.write(scene_content)
        print(f"  {level_name}: Created scene file {scene_path}")

    # Write levels configuration to a file for the game to read
    config_path = os.path.join("levels_config.json")
    with open(config_path, 'w') as f:
        json.dump({"levels": levels_config}, f, indent=2)
    print(f"Wrote levels configuration to: {config_path}")


def main():
    setup_player_svg()
    setup_npc()
    setup_victory_sound()

    # Setup levels if count > 1
    if LEVEL_COUNT > 1:
        levels_config = load_levels_config()
        setup_levels(levels_config)
    else:
        print("Single level mode - no level configuration needed")


if __name__ == "__main__":
    main()
