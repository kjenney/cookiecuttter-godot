# Installation

This guide will help you install and set up the Godot 4 2D Platformer Builder template.

## Prerequisites

Before using this template, you'll need:

### Godot 4.0+

Download and install Godot 4 from the official website:

- [Godot Engine Download](https://godotengine.org/download)
- Minimum version: 4.0
- Recommended: Latest stable version (4.5+)

### Cookiecutter

Cookiecutter is a command-line utility that creates projects from templates.

Install via pip:

```bash
pip install cookiecutter
```

Or using pipx (recommended for isolated installation):

```bash
pipx install cookiecutter
```

### Python 3.7+

Cookiecutter requires Python 3.7 or higher. Check your version:

```bash
python --version
```

If you need to install Python:

- **macOS**: Use Homebrew: `brew install python`
- **Linux**: Use your package manager: `apt install python3` or `dnf install python3`
- **Windows**: Download from [python.org](https://www.python.org/downloads/)

## Installation Steps

### 1. Clone or Download the Template

Clone the repository:

```bash
git clone https://github.com/your-repo/cookiecutter-godot.git
cd cookiecutter-godot
```

Or download and extract the ZIP file from the repository.

### 2. Verify Cookiecutter Installation

Test that cookiecutter is installed correctly:

```bash
cookiecutter --version
```

You should see output like: `Cookiecutter 2.x.x`

### 3. Prepare Your Assets (Optional)

If you want to use custom graphics:

1. Create SVG files for player characters
2. Create SVG files for NPCs
3. Prepare a WAV or OGG victory sound file
4. Note the file paths - you'll need them during configuration

Supported formats:

- **Graphics**: SVG (Scalable Vector Graphics)
- **Audio**: WAV, OGG

## Verification

To verify your setup is complete:

```bash
# Check Godot
godot --version

# Check Cookiecutter
cookiecutter --version

# Check Python
python --version
```

All commands should execute without errors.

## Next Steps

Once installation is complete, proceed to:

- [Quick Start Guide](quick-start.md) - Generate your first game
- [Configuration Guide](configuration.md) - Learn about configuration options
- [Examples](examples.md) - See example configurations

## Troubleshooting

### Cookiecutter not found

If `cookiecutter` command is not found:

1. Ensure pip/pipx installation completed successfully
2. Check that your Python scripts directory is in your PATH
3. Try running with `python -m cookiecutter` instead

### Godot not found

If you installed Godot but can't run it from command line:

- **macOS**: Add Godot to PATH or use the full path to the application
- **Linux**: Ensure the godot binary is in `/usr/local/bin` or similar
- **Windows**: Add Godot installation directory to system PATH

### Permission errors

If you get permission errors during pip install:

```bash
# Use --user flag
pip install --user cookiecutter

# Or use a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install cookiecutter
```

## System Requirements

### Minimum Requirements

- **OS**: Windows 10, macOS 10.13+, or modern Linux distribution
- **RAM**: 4 GB
- **Disk Space**: 500 MB for Godot + generated projects
- **Python**: 3.7+

### Recommended Requirements

- **RAM**: 8 GB or more
- **Disk Space**: 2 GB for development
- **Display**: 1920x1080 or higher

## Development Tools (Optional)

While not required, these tools enhance the development experience:

- **VS Code**: With Godot Tools extension
- **Git**: For version control
- **Image Editor**: Inkscape or Adobe Illustrator for SVG creation
- **Audio Editor**: Audacity for custom sound effects
