# Neoradus Rotation Game

A spatial reasoning puzzle game built with **SwiftUI** for iOS. Players decode rotation transformations applied to 3D block structures and must apply the same transformation to new structures. Part of the **Neoradus** lineup of visual logic puzzles.

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-purple)

## Features

### Core Gameplay
- **Isometric 3D Rendering** — Block structures rendered in beautiful isometric projection using SwiftUI Canvas
- **Rotation Puzzles** — Decode a transformation pattern shown on a reference structure and apply it to a question structure
- **4 Difficulty Levels** — Beginner to Expert with increasing rotation complexity
- **Timed Challenges** — Time pressure adds intensity; faster correct answers earn bonus points
- **Scoring System** — Base points + time bonus + streak multiplier

### Design & UX
- **Modern Dark UI** — Sleek dark theme with animated gradient backgrounds
- **Glassmorphism** — Frosted glass card effects throughout the interface
- **Neon Glow Effects** — Subtle neon accents on interactive elements
- **Smooth Animations** — Spring-based animations on all transitions and interactions
- **Haptic Feedback** — Tactile response on selections and answers
- **Animated Splash Screen** — Rotating geometric elements with fade-in branding
- **Grade System** — S/A/B/C/D rank with animated progress ring on results

### Spatial Reasoning
- **Single-axis rotations** (beginner): Y and Z axis 90° rotations
- **All-axis rotations** (intermediate): Full X/Y/Z in both directions
- **Multi-step rotations** (advanced/expert): Composed transformations requiring multi-axial mental simulation
- **10 predefined 3D structures** from simple L-shapes to complex spirals

## Project Structure

```
RotationGame/
├── Sources/
│   ├── RotationGameApp.swift          # App entry point
│   ├── ContentView.swift              # Root view with splash + navigation
│   ├── Models/
│   │   ├── BlockStructure.swift       # 3D block structure model with rotations
│   │   ├── Rotation.swift             # Rotation axis/transformation definitions
│   │   ├── Difficulty.swift           # Difficulty levels and configuration
│   │   └── Puzzle.swift               # Puzzle model and procedural generation
│   ├── ViewModels/
│   │   └── GameManager.swift          # Central game state (ObservableObject)
│   ├── Views/
│   │   ├── MenuView.swift             # Main menu with difficulty selection
│   │   ├── GameView.swift             # Active gameplay screen
│   │   ├── ResultsView.swift          # Post-game results with grading
│   │   └── Components/
│   │       ├── IsometricBlockView.swift     # Isometric 3D block renderer
│   │       ├── TimerBarView.swift           # Animated timer + score display
│   │       ├── RotationIndicatorView.swift  # Rotation axis badges + feedback
│   │       └── ParticleView.swift           # Particle effects + confetti
│   └── Utilities/
│       ├── NeoradusTheme.swift        # Design system (colors, gradients, modifiers)
│       ├── IsometricRenderer.swift    # Isometric projection math
│       └── SoundManager.swift         # Haptic feedback manager
├── Assets.xcassets/                   # App icon + accent color assets
└── Package.swift                      # Swift Package Manager configuration
```

## Getting Started

### Prerequisites
- **Xcode 15+** (for iOS 17 / SwiftUI support)
- **iOS 17+** target device or simulator
- **macOS 14+** (Sonoma) for development

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rikhinkavuru/rotationtest.git
   cd rotationtest
   ```

2. **Open in Xcode:**
   - Open Xcode and select **File → Open** or **File → New → Project from Version Control**
   - Create a new iOS App project in Xcode
   - Copy the `RotationGame/Sources/` files into your Xcode project
   - Copy the `RotationGame/Assets.xcassets/` into your project assets

3. **Alternative — Use Swift Package Manager:**
   ```bash
   swift build
   ```

4. **Build & Run:**
   - Select your target device/simulator (iPhone 15 Pro recommended)
   - Press **⌘R** to build and run

### App Store Submission
1. Create a new Xcode project (App template, SwiftUI lifecycle)
2. Replace the generated source files with the files from `RotationGame/Sources/`
3. Copy asset catalogs
4. Configure your bundle identifier, team, and signing
5. Archive and submit via Xcode Organizer

## How to Play

1. **Observe** the reference structure and its rotated version (shown side by side)
2. **Identify** the rotation transformation that was applied (axis + direction)
3. **Mentally apply** that same rotation to the question structure below
4. **Select** the correct answer from the multiple-choice options
5. **Score** points based on accuracy, speed, and streaks

### Tips
- Use the **hint button** (💡) to reveal the rotation axis — but at a score penalty
- Use the **skip button** (⏭) to move to the next puzzle without scoring
- Focus on how individual blocks move relative to each other during rotation
- Start with **Beginner** to build spatial intuition before advancing

## Technical Details

### Isometric Projection
The game uses true isometric projection with a 30° angle:
- `screenX = (x - z) × cos(30°) × scale`
- `screenY = (x + z) × sin(30°) × scale - y × scale`

Each block face (top, left, right) is rendered with different shading for depth perception. A painter's algorithm sorts blocks back-to-front for correct occlusion.

### Rotation System
Rotations are composed of 90° steps around the three principal axes:
- **X-axis**: `(x, y, z) → (x, -z, y)`
- **Y-axis**: `(x, y, z) → (z, y, -x)`
- **Z-axis**: `(x, y, z) → (-y, x, z)`

Multi-step rotations are composed sequentially, and structures are normalized to maintain origin-aligned positions.

## License

This project is available for educational and personal use.