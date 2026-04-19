// NeoradusTheme.swift
// Neoradus Rotation Game

import SwiftUI

/// Design system for the Neoradus Rotation Game
enum NeoradusTheme {
    // MARK: - Colors

    static let accentCyan = Color(red: 0.0, green: 0.85, blue: 0.95)
    static let accentPurple = Color(red: 0.55, green: 0.35, blue: 1.0)
    static let accentPink = Color(red: 1.0, green: 0.3, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentGreen = Color(red: 0.2, green: 0.9, blue: 0.5)

    static let surfacePrimary = Color(red: 0.08, green: 0.08, blue: 0.14)
    static let surfaceSecondary = Color(red: 0.12, green: 0.12, blue: 0.2)
    static let surfaceTertiary = Color(red: 0.16, green: 0.16, blue: 0.26)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.4)

    // MARK: - Gradients

    static let primaryGradient = LinearGradient(
        colors: [accentCyan, accentPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let warmGradient = LinearGradient(
        colors: [accentOrange, accentPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        colors: [accentGreen, accentCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Block Colors for Isometric Rendering

    struct BlockColors {
        let top: Color
        let left: Color
        let right: Color
    }

    static let blockPalette: [BlockColors] = [
        BlockColors(
            top: Color(red: 0.3, green: 0.7, blue: 0.95),
            left: Color(red: 0.2, green: 0.5, blue: 0.75),
            right: Color(red: 0.15, green: 0.4, blue: 0.6)
        ),
        BlockColors(
            top: Color(red: 0.65, green: 0.45, blue: 0.95),
            left: Color(red: 0.5, green: 0.3, blue: 0.75),
            right: Color(red: 0.4, green: 0.25, blue: 0.6)
        ),
        BlockColors(
            top: Color(red: 0.95, green: 0.5, blue: 0.3),
            left: Color(red: 0.75, green: 0.35, blue: 0.2),
            right: Color(red: 0.6, green: 0.3, blue: 0.15)
        ),
        BlockColors(
            top: Color(red: 0.3, green: 0.9, blue: 0.6),
            left: Color(red: 0.2, green: 0.7, blue: 0.45),
            right: Color(red: 0.15, green: 0.55, blue: 0.35)
        ),
    ]

    static func blockColors(forIndex index: Int) -> BlockColors {
        blockPalette[index % blockPalette.count]
    }
}

// MARK: - Glass Morphism Modifier

struct GlassMorphism: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.1

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(opacity)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func glassMorphism(cornerRadius: CGFloat = 20, opacity: Double = 0.1) -> some View {
        modifier(GlassMorphism(cornerRadius: cornerRadius, opacity: opacity))
    }
}

// MARK: - Neon Glow Modifier

struct NeonGlow: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius / 2)
            .shadow(color: color.opacity(0.3), radius: radius)
    }
}

extension View {
    func neonGlow(color: Color = NeoradusTheme.accentCyan, radius: CGFloat = 10) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }
}

// MARK: - Pulse Animation Modifier

struct PulseAnimation: ViewModifier {
    @State private var isPulsing = false
    let color: Color

    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .foregroundColor(color)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                    .opacity(isPulsing ? 0 : 0.5)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulseEffect(color: Color = NeoradusTheme.accentCyan) -> some View {
        modifier(PulseAnimation(color: color))
    }
}
