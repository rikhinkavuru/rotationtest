// ParticleView.swift
// Neoradus Rotation Game

import SwiftUI

/// Floating particle effect for visual flair
struct ParticleView: View {
    let particleCount: Int
    let color: Color

    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: CGFloat
    }

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x * size.width,
                        y: particle.y * size.height,
                        width: particle.size,
                        height: particle.size
                    )
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(color.opacity(particle.opacity))
                    )
                }
            }
            .onAppear {
                generateParticles()
                startAnimation()
            }
            .onDisappear {
                stopAnimation()
            }
        }
        .allowsHitTesting(false)
    }

    private func generateParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 1...4),
                opacity: Double.random(in: 0.1...0.4),
                speed: CGFloat.random(in: 0.001...0.003)
            )
        }
    }

    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            for i in particles.indices {
                particles[i].y -= particles[i].speed
                if particles[i].y < -0.05 {
                    particles[i].y = 1.05
                    particles[i].x = CGFloat.random(in: 0...1)
                }
            }
        }
    }

    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

// MARK: - Confetti Effect for Correct Answers

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var isAnimating = false

    struct ConfettiPiece: Identifiable {
        let id = UUID()
        let color: Color
        let startX: CGFloat
        var offsetY: CGFloat = 0
        var offsetX: CGFloat = 0
        var rotation: Double = 0
        var opacity: Double = 1
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: 8, height: 5)
                        .rotationEffect(.degrees(piece.rotation))
                        .offset(
                            x: piece.startX + piece.offsetX,
                            y: piece.offsetY
                        )
                        .opacity(piece.opacity)
                }
            }
            .onAppear {
                spawnConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }

    private func spawnConfetti(in size: CGSize) {
        let colors: [Color] = [
            NeoradusTheme.accentCyan,
            NeoradusTheme.accentPurple,
            NeoradusTheme.accentGreen,
            NeoradusTheme.accentOrange,
            NeoradusTheme.accentPink
        ]

        confettiPieces = (0..<30).map { _ in
            ConfettiPiece(
                color: colors.randomElement()!,
                startX: CGFloat.random(in: 0...size.width)
            )
        }

        for i in confettiPieces.indices {
            withAnimation(
                .easeOut(duration: Double.random(in: 1.5...2.5))
            ) {
                confettiPieces[i].offsetY = size.height + 20
                confettiPieces[i].offsetX = CGFloat.random(in: -50...50)
                confettiPieces[i].rotation = Double.random(in: 0...720)
                confettiPieces[i].opacity = 0
            }
        }
    }
}
