// RotationIndicatorView.swift
// Neoradus Rotation Game

import SwiftUI

/// Visual indicator showing the rotation axis and direction
struct RotationIndicatorView: View {
    let rotation: Rotation3D
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 4 : 8) {
            ForEach(Array(rotation.steps.enumerated()), id: \.offset) { index, axis in
                if index > 0 {
                    Image(systemName: "arrow.right")
                        .font(.system(size: compact ? 8 : 10))
                        .foregroundColor(NeoradusTheme.textTertiary)
                }

                AxisBadge(axis: axis, compact: compact)
            }
        }
    }
}

struct AxisBadge: View {
    let axis: RotationAxis
    var compact: Bool = false

    private var badgeColor: Color {
        switch axis {
        case .x, .negX: return NeoradusTheme.accentPink
        case .y, .negY: return NeoradusTheme.accentCyan
        case .z, .negZ: return NeoradusTheme.accentPurple
        }
    }

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: axis.iconName)
                .font(.system(size: compact ? 10 : 12, weight: .medium))

            Text(axis.displayName)
                .font(.system(size: compact ? 9 : 11, weight: .semibold, design: .monospaced))
        }
        .foregroundColor(badgeColor)
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 5)
        .background(
            Capsule()
                .fill(badgeColor.opacity(0.15))
        )
        .overlay(
            Capsule()
                .stroke(badgeColor.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Feedback Overlay

struct FeedbackOverlay: View {
    let isCorrect: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (isCorrect ? NeoradusTheme.accentGreen : NeoradusTheme.accentPink).opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)

            VStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(isCorrect ? NeoradusTheme.accentGreen : NeoradusTheme.accentPink)

                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isCorrect ? NeoradusTheme.accentGreen : NeoradusTheme.accentPink)
            }
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
