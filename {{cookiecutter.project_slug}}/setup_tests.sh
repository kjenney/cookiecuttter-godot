#!/usr/bin/env bash

# Setup script for GUT testing framework
# This script helps install and configure GUT for your Godot project

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDONS_DIR="$PROJECT_DIR/addons"
GUT_DIR="$ADDONS_DIR/gut"

echo "=== GUT Testing Framework Setup ==="
echo "Project directory: $PROJECT_DIR"
echo ""

# Check if Godot is installed
if ! command -v godot &> /dev/null; then
    echo "⚠️  Warning: 'godot' command not found in PATH"
    echo "   Please ensure Godot is installed and accessible via command line"
    echo "   You can still install GUT manually via the Godot Asset Library"
    echo ""
fi

# Check if GUT is already installed
if [ -d "$GUT_DIR" ]; then
    echo "✓ GUT is already installed at: $GUT_DIR"
    echo ""
else
    echo "GUT not found. Installation options:"
    echo ""
    echo "Option 1 (Recommended): Install via Godot Asset Library"
    echo "  1. Open your project in Godot"
    echo "  2. Click on 'AssetLib' tab"
    echo "  3. Search for 'GUT'"
    echo "  4. Download and install 'Gut - Godot Unit Testing'"
    echo ""
    echo "Option 2: Manual installation"
    echo "  1. Download from: https://github.com/bitwes/Gut/releases"
    echo "  2. Extract to: $ADDONS_DIR/gut"
    echo ""
    echo "Option 3: Clone from GitHub"
    read -p "Would you like to clone GUT from GitHub now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$ADDONS_DIR"
        cd "$ADDONS_DIR"
        echo "Cloning GUT repository..."
        git clone https://github.com/bitwes/Gut.git gut
        echo "✓ GUT cloned successfully"
        echo ""
    fi
fi

# Check if .gutconfig.json exists
if [ -f "$PROJECT_DIR/.gutconfig.json" ]; then
    echo "✓ GUT configuration file found: .gutconfig.json"
else
    echo "⚠️  Warning: .gutconfig.json not found"
    echo "   This file should have been created automatically"
fi

# Check if tests directory exists
if [ -d "$PROJECT_DIR/tests" ]; then
    echo "✓ Tests directory found: tests/"
    TEST_COUNT=$(find "$PROJECT_DIR/tests" -name "test_*.gd" | wc -l)
    echo "  Found $TEST_COUNT test file(s)"
else
    echo "⚠️  Warning: tests/ directory not found"
fi

echo ""
echo "=== Next Steps ==="
echo ""
echo "1. Open your project in Godot"
echo "2. Enable the GUT plugin:"
echo "   Project → Project Settings → Plugins → Enable 'Gut'"
echo ""
echo "3. Run tests from Godot:"
echo "   - Look for the 'Gut' tab in the bottom panel"
echo "   - Click 'Run All' to run all tests"
echo ""
echo "4. Or run tests from command line:"
echo "   godot --headless -s addons/gut/gut_cmdln.gd"
echo ""
echo "For more information, see tests/README.md"
echo ""
