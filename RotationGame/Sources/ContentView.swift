// ContentView.swift
// Neoradus Rotation Game

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showSplash = true

    var body: some View {
        ZStack {
            // Global animated gradient background
            AnimatedGradientBackground()
                .ignoresSafeArea()

            if showSplash {
                SplashView()
                    .transition(.opacity.combined(with: .scale(scale: 1.1)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                NavigationStack {
                    switch gameManager.currentScreen {
                    case .menu:
                        MenuView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    case .game:
                        GameView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    case .results:
                        ResultsView()
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity),
                                removal: .scale(scale: 0.8).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: gameManager.currentScreen)
    }
}

// MARK: - Splash View

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var rotationAngle: Double = 0
    @State private var subtitleOpacity: Double = 0

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // Rotating geometric accent
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    NeoradusTheme.accentCyan.opacity(0.6),
                                    NeoradusTheme.accentPurple.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 80 + CGFloat(i * 20), height: 80 + CGFloat(i * 20))
                        .rotationEffect(.degrees(rotationAngle + Double(i) * 30))
                }

                Image(systemName: "cube.transparent")
                    .font(.system(size: 50, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [NeoradusTheme.accentCyan, NeoradusTheme.accentPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            VStack(spacing: 8) {
                Text("NEORADUS")
                    .font(.system(size: 36, weight: .ultraLight, design: .default))
                    .tracking(12)
                    .foregroundColor(.white)

                Text("ROTATION")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .tracking(8)
                    .foregroundColor(NeoradusTheme.accentCyan.opacity(0.7))
            }
            .opacity(subtitleOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.4)) {
                subtitleOpacity = 1.0
            }
        }
    }
}

// MARK: - Animated Gradient Background

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.04, blue: 0.12),
                Color(red: 0.08, green: 0.05, blue: 0.18),
                Color(red: 0.04, green: 0.08, blue: 0.16),
                Color(red: 0.02, green: 0.02, blue: 0.08)
            ],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}
