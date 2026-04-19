// Difficulty.swift
// Neoradus Rotation Game

import SwiftUI

enum Difficulty: String, CaseIterable, Codable {
    case beginner
    case intermediate
    case advanced
    case expert

    var displayName: String {
        rawValue.capitalized
    }

    var description: String {
        switch self {
        case .beginner:
            return "Single-axis rotations with simple shapes"
        case .intermediate:
            return "All axes with moderate complexity"
        case .advanced:
            return "Multi-step rotations with 3D structures"
        case .expert:
            return "Complex multi-axial transformations"
        }
    }

    var puzzleCount: Int {
        switch self {
        case .beginner: return 8
        case .intermediate: return 10
        case .advanced: return 12
        case .expert: return 15
        }
    }

    var timeLimit: TimeInterval {
        switch self {
        case .beginner: return 30
        case .intermediate: return 25
        case .advanced: return 20
        case .expert: return 15
        }
    }

    var accentColor: Color {
        switch self {
        case .beginner: return NeoradusTheme.accentCyan
        case .intermediate: return NeoradusTheme.accentPurple
        case .advanced: return NeoradusTheme.accentOrange
        case .expert: return NeoradusTheme.accentPink
        }
    }

    var icon: String {
        switch self {
        case .beginner: return "cube"
        case .intermediate: return "cube.fill"
        case .advanced: return "cube.transparent"
        case .expert: return "cube.transparent.fill"
        }
    }

    var optionCount: Int {
        switch self {
        case .beginner: return 3
        case .intermediate: return 4
        case .advanced: return 4
        case .expert: return 5
        }
    }
}
