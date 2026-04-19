// Rotation.swift
// Neoradus Rotation Game

import Foundation

/// Represents a single-axis rotation direction
enum RotationAxis: String, CaseIterable, Codable, Hashable {
    case x      // +90° around X axis
    case negX   // -90° around X axis
    case y      // +90° around Y axis
    case negY   // -90° around Y axis
    case z      // +90° around Z axis
    case negZ   // -90° around Z axis

    var displayName: String {
        switch self {
        case .x:    return "X ↻"
        case .negX: return "X ↺"
        case .y:    return "Y ↻"
        case .negY: return "Y ↺"
        case .z:    return "Z ↻"
        case .negZ: return "Z ↺"
        }
    }

    var description: String {
        switch self {
        case .x:    return "Rotate 90° around X-axis (forward)"
        case .negX: return "Rotate 90° around X-axis (backward)"
        case .y:    return "Rotate 90° around Y-axis (clockwise)"
        case .negY: return "Rotate 90° around Y-axis (counter-clockwise)"
        case .z:    return "Rotate 90° around Z-axis (clockwise)"
        case .negZ: return "Rotate 90° around Z-axis (counter-clockwise)"
        }
    }

    /// The icon name for visual representation
    var iconName: String {
        switch self {
        case .x:    return "arrow.turn.right.up"
        case .negX: return "arrow.turn.left.up"
        case .y:    return "arrow.clockwise"
        case .negY: return "arrow.counterclockwise"
        case .z:    return "arrow.turn.up.right"
        case .negZ: return "arrow.turn.up.left"
        }
    }
}

/// Represents a composed rotation (one or more 90° steps)
struct Rotation3D: Hashable, Codable {
    let steps: [RotationAxis]

    var displayName: String {
        steps.map(\.displayName).joined(separator: " → ")
    }

    var complexity: Int {
        steps.count
    }

    /// Generate single-step rotations
    static var singleRotations: [Rotation3D] {
        RotationAxis.allCases.map { Rotation3D(steps: [$0]) }
    }

    /// Generate two-step rotations
    static var doubleRotations: [Rotation3D] {
        var rotations: [Rotation3D] = []
        for first in RotationAxis.allCases {
            for second in RotationAxis.allCases {
                rotations.append(Rotation3D(steps: [first, second]))
            }
        }
        return rotations
    }

    /// Generate rotations appropriate for a difficulty level
    static func rotationsForDifficulty(_ difficulty: Difficulty) -> [Rotation3D] {
        switch difficulty {
        case .beginner:
            // Single axis rotations, restricted to Y and Z for easier visualization
            return [.y, .negY, .z, .negZ].map { Rotation3D(steps: [$0]) }
        case .intermediate:
            // All single axis rotations
            return singleRotations
        case .advanced:
            // Single and select double rotations
            return singleRotations + doubleRotations.shuffled().prefix(12).map { $0 }
        case .expert:
            // All combinations
            return singleRotations + doubleRotations
        }
    }
}
