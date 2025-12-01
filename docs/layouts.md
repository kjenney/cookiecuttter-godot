# Collectible Layouts

Complete guide to the 8 collectible placement patterns available in the platformer template.

## Overview

Each level can use a different layout pattern to position collectibles. Layouts create visual variety and unique gameplay challenges.

## Available Layouts

### Grid Layout

**Pattern**: Evenly spaced rows and columns

**Best For**:
- Balanced gameplay
- Traditional level design
- Predictable collection paths

**Behavior**:
- Maximum 4 columns
- Automatic row calculation based on collectible count
- Centered on screen
- Equal spacing between items

**Example**:
- 4 collectibles → 2×2 grid
- 6 collectibles → 2×3 grid
- 9 collectibles → 3×3 grid

**Use in Config**:
```json
{
  "layout": "grid"
}
```

**Visual Pattern** (6 collectibles):
```
    O   O   O
    
    O   O   O
```

---

### Circle Layout

**Pattern**: Collectibles arranged in a perfect circle

**Best For**:
- Circular movement patterns
- Dodge-style gameplay
- Visual appeal

**Behavior**:
- Circle centered on screen
- Radius automatically calculated
- Even angular distribution
- Perfect 360° coverage

**Example**:
- 4 collectibles → 90° apart (0°, 90°, 180°, 270°)
- 8 collectibles → 45° apart

**Use in Config**:
```json
{
  "layout": "circle"
}
```

**Visual Pattern** (8 collectibles):
```
        O
    O       O
O               O
    O       O
        O
```

---

### Horizontal Layout

**Pattern**: Single horizontal line across screen

**Best For**:
- Side-scrolling feel
- Linear progression
- Simple collection

**Behavior**:
- All collectibles in single row
- Evenly spaced horizontally
- Vertically centered
- Full width distribution

**Use in Config**:
```json
{
  "layout": "horizontal"
}
```

**Visual Pattern** (6 collectibles):
```
O     O     O     O     O     O
```

---

### Vertical Layout

**Pattern**: Single vertical line down screen

**Best For**:
- Vertical movement challenges
- Jumping practice
- Climbing simulation

**Behavior**:
- All collectibles in single column
- Evenly spaced vertically
- Horizontally centered
- Full height distribution

**Use in Config**:
```json
{
  "layout": "vertical"
}
```

**Visual Pattern** (5 collectibles):
```
    O
    
    O
    
    O
    
    O
    
    O
```

---

### Diagonal Layout

**Pattern**: Diagonal line from top-left to bottom-right

**Best For**:
- Diagonal movement patterns
- Unique visual appeal
- Directional flow

**Behavior**:
- Straight diagonal line
- Equal spacing along diagonal
- Extends from corner to corner
- Symmetric placement

**Use in Config**:
```json
{
  "layout": "diagonal"
}
```

**Visual Pattern** (5 collectibles):
```
O
    O
        O
            O
                O
```

---

### Corners Layout

**Pattern**: First 4 in corners, extras in center

**Best For**:
- Exploration-focused gameplay
- Screen coverage
- Mixed collection patterns

**Behavior**:
- First 4 collectibles in four corners
- Additional collectibles (if > 4) in center grid
- Maximum screen coverage
- Combines corners + grid

**Example**:
- 4 collectibles → All in corners
- 6 collectibles → 4 corners + 2 center
- 8 collectibles → 4 corners + 4 center grid

**Use in Config**:
```json
{
  "layout": "corners"
}
```

**Visual Pattern** (6 collectibles):
```
O               O

      O   O

O               O
```

---

### Random Layout

**Pattern**: Randomly distributed with spacing

**Best For**:
- Unpredictable challenges
- Varied gameplay
- Exploration

**Behavior**:
- Random positions each generation
- Minimum 120-pixel spacing between items
- Prevents overlap
- Different every time

**Use in Config**:
```json
{
  "layout": "random"
}
```

**Visual Pattern** (example, varies):
```
    O       O
O               
            O
        O       O
    O
```

---

### Scatter Layout

**Pattern**: Wide random distribution

**Best For**:
- Large movement patterns
- Sparse distribution
- Exploration emphasis

**Behavior**:
- Similar to random but wider spacing
- Minimum 180-pixel spacing
- More spread out than random
- Maximum screen utilization

**Use in Config**:
```json
{
  "layout": "scatter"
}
```

**Visual Pattern** (example, varies):
```
O                   
                O
        O           
                    O
    O
```

## Technical Details

### Screen Dimensions

Layouts are designed for default screen size:
- **Width**: 1152 pixels
- **Height**: 648 pixels
- **Safety Margin**: 150 pixels from edges

### Platformer Integration

In platformer mode, collectibles are placed **above platforms**:

- **Platform Heights**: 250px, 350px, 450px above ground
- **Collectible Offset**: 100px above platform surface
- **Distribution**: Spread across available platforms

Layouts still apply but work within platform constraints.

### Algorithm Details

#### Grid Calculation
```python
columns = min(count, 4)
rows = (count + columns - 1) // columns
spacing_x = screen_width / (columns + 1)
spacing_y = screen_height / (rows + 1)
```

#### Circle Calculation
```python
radius = min(screen_width, screen_height) * 0.35
angle_step = 2 * pi / count
for i in range(count):
    angle = i * angle_step
    x = center_x + radius * cos(angle)
    y = center_y + radius * sin(angle)
```

#### Random/Scatter Placement
```python
min_spacing = 120  # random layout
min_spacing = 180  # scatter layout

while len(positions) < count:
    new_pos = random_position()
    if min_distance(new_pos, positions) > min_spacing:
        positions.append(new_pos)
```

## Choosing Layouts

### By Difficulty

**Easy** (Predictable):
- Grid
- Horizontal
- Vertical

**Medium** (Pattern-Based):
- Circle
- Diagonal
- Corners

**Hard** (Unpredictable):
- Random
- Scatter

### By Collectible Count

**1-4 Collectibles**:
- Circle (perfect spacing)
- Corners (if exactly 4)
- Diagonal (clean line)

**5-8 Collectibles**:
- Grid (balanced)
- Horizontal (linear)
- Random (variety)

**9+ Collectibles**:
- Grid (organized)
- Scatter (prevents clustering)
- Random (varied)

### By Gameplay Style

**Methodical Collection**:
- Grid: Systematic collection
- Horizontal: Left-to-right sweep
- Vertical: Bottom-to-top climb

**Exploration**:
- Random: Search required
- Scatter: Wide exploration
- Corners: Maximum coverage

**Movement Challenge**:
- Circle: Circular paths
- Diagonal: Angled movement
- Vertical: Jumping practice

## Progressive Difficulty Examples

### Tutorial → Challenge

```json
{
  "levels": [
    {
      "name": "tutorial",
      "collectibles": 4,
      "layout": "grid"
    },
    {
      "name": "intermediate",
      "collectibles": 6,
      "layout": "horizontal"
    },
    {
      "name": "advanced",
      "collectibles": 8,
      "layout": "random"
    }
  ]
}
```

### Pattern Progression

```json
{
  "levels": [
    {
      "name": "grid_intro",
      "collectibles": 4,
      "layout": "grid"
    },
    {
      "name": "circle_challenge",
      "collectibles": 6,
      "layout": "circle"
    },
    {
      "name": "diagonal_test",
      "collectibles": 8,
      "layout": "diagonal"
    },
    {
      "name": "random_finale",
      "collectibles": 10,
      "layout": "random"
    }
  ]
}
```

## Layout Combinations

### Mixed Strategy

Use different layouts for variety:

```json
{
  "levels": [
    { "layout": "grid" },
    { "layout": "circle" },
    { "layout": "horizontal" },
    { "layout": "scatter" },
    { "layout": "diagonal" }
  ]
}
```

### Themed Levels

Match layouts to level themes:

- **Forest**: `scatter` (natural distribution)
- **Cave**: `random` (chaotic)
- **Temple**: `grid` (organized)
- **Sky**: `circle` (floating pattern)

## Customizing Layouts

### Modifying Existing Layouts

Edit `hooks/post_gen_project.py`:

```python
def generate_collectible_positions(count, layout='grid', screen_width=1152, screen_height=648):
    if layout == 'grid':
        # Modify grid spacing
        columns = min(count, 3)  # Changed from 4
        # ... rest of grid logic
```

### Adding New Layouts

Add custom pattern to `generate_collectible_positions()`:

```python
elif layout == 'custom':
    # Your custom layout logic
    positions = []
    for i in range(count):
        x = custom_x_calculation(i)
        y = custom_y_calculation(i)
        positions.append((x, y))
    return positions
```

Then use in config:
```json
{
  "layout": "custom"
}
```

## Visual Examples

### Grid vs Circle (6 collectibles)

**Grid:**
```
    O   O   O
    
    O   O   O
```

**Circle:**
```
        O
    O       O

O           O
        O
```

### Horizontal vs Vertical (5 collectibles)

**Horizontal:**
```
O     O     O     O     O
```

**Vertical:**
```
         O
         O
         O
         O
         O
```

### Random vs Scatter (6 collectibles)

**Random** (closer spacing):
```
  O   O     O
      O
    O     O
```

**Scatter** (wider spacing):
```
O             O
    
          O
O
              O
                  O
```

## Performance Considerations

### Layout Generation Time

- **Fast** (pre-calculated): Grid, Horizontal, Vertical, Diagonal, Circle
- **Moderate** (iteration): Corners
- **Slower** (random with collision): Random, Scatter

### Memory Usage

All layouts use minimal memory (just position coordinates).

### Collision Checks

Random and Scatter perform distance checks to ensure spacing:
- **Random**: ~10-20 checks per collectible
- **Scatter**: ~15-30 checks per collectible

## Troubleshooting

### Collectibles Too Close

**Issue**: Items overlapping

**Solutions**:
- Use scatter instead of random (larger spacing)
- Reduce collectible count
- Modify minimum spacing in code

### Uneven Distribution

**Issue**: Collectibles clustered in one area

**Solutions**:
- Use grid or circle (even distribution)
- Increase screen margins in code
- Check random seed initialization

### Collectibles Off-Screen

**Issue**: Items not visible

**Solutions**:
- Check safety margin (150px default)
- Verify screen dimensions match project
- Review camera limits

## Next Steps

- [Level Configuration](levels.md) - Apply layouts to levels
- [Examples](examples.md) - See layout usage examples
- [Customization](customization.md) - Modify layout behavior
