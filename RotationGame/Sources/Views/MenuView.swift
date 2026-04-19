// MenuView.swift
// Neoradus Rotation Game

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedDifficulty: Difficulty = .beginner
    @State private var showDifficultyInfo = false
    @State private var headerRotation: Double = 0
    @State private var appearAnimation = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Header
                headerSection
                    .padding(.top, 20)

                // Difficulty selector
                difficultySection

                // Start button
                startButton

                // Stats section
                statsSection

                // Info section
                infoSection
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                appearAnimation = true
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                headerRotation = 360
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Decorative rotating rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    NeoradusTheme.accentCyan.opacity(0.3 - Double(i) * 0.08),
                                    NeoradusTheme.accentPurple.opacity(0.2 - Double(i) * 0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 1, dash: [5 + CGFloat(i) * 3, 3 + CGFloat(i) * 2])
                        )
                        .frame(width: 100 + CGFloat(i) * 30, height: 100 + CGFloat(i) * 30)
                        .rotationEffect(.degrees(headerRotation * (i % 2 == 0 ? 1 : -1)))
                }

                Image(systemName: "rotate.3d")
                    .font(.system(size: 40, weight: .ultraLight))
                    .foregroundStyle(NeoradusTheme.primaryGradient)
            }

            VStack(spacing: 6) {
                Text("NEORADUS")
                    .font(.system(size: 28, weight: .ultraLight))
                    .tracking(10)
                    .foregroundColor(.white)

                Text("ROTATION")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .tracking(6)
                    .foregroundColor(NeoradusTheme.accentCyan.opacity(0.7))
            }

            Text("Decode the transformation. Apply the shift.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(NeoradusTheme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : -20)
    }

    // MARK: - Difficulty Selector

    private var difficultySection: some View {
        VStack(spacing: 16) {
            Text("SELECT DIFFICULTY")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(3)
                .foregroundColor(NeoradusTheme.textTertiary)

            VStack(spacing: 10) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyCard(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedDifficulty = difficulty
                        }
                    }
                }
            }
        }
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 20)
    }

    // MARK: - Start Button

    private var startButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            gameManager.startGame(difficulty: selectedDifficulty)
        }) {
            HStack(spacing: 12) {
                Text("BEGIN SESSION")
                    .font(.system(size: 15, weight: .semibold, design: .monospaced))
                    .tracking(3)

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [selectedDifficulty.accentColor, selectedDifficulty.accentColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .neonGlow(color: selectedDifficulty.accentColor, radius: 8)
        }
        .opacity(appearAnimation ? 1 : 0)
        .scaleEffect(appearAnimation ? 1 : 0.9)
    }

    // MARK: - Stats

    private var statsSection: some View {
        Group {
            if gameManager.totalGamesPlayed > 0 {
                VStack(spacing: 12) {
                    Text("STATISTICS")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(NeoradusTheme.textTertiary)

                    HStack(spacing: 16) {
                        StatCard(
                            icon: "gamecontroller",
                            value: "\(gameManager.totalGamesPlayed)",
                            label: "Games"
                        )
                        StatCard(
                            icon: "checkmark.circle",
                            value: "\(gameManager.lifetimeCorrect)",
                            label: "Correct"
                        )
                        StatCard(
                            icon: "flame",
                            value: "\(gameManager.lifetimeBestStreak)",
                            label: "Best Streak"
                        )
                    }
                }
                .glassMorphism()
                .padding(.vertical, 16)
                .opacity(appearAnimation ? 1 : 0)
            }
        }
    }

    // MARK: - Info

    private var infoSection: some View {
        VStack(spacing: 12) {
            Text("HOW TO PLAY")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(3)
                .foregroundColor(NeoradusTheme.textTertiary)

            VStack(alignment: .leading, spacing: 10) {
                InfoRow(icon: "1.circle.fill", text: "Observe the reference structure and its rotation")
                InfoRow(icon: "2.circle.fill", text: "Identify the rotation transformation applied")
                InfoRow(icon: "3.circle.fill", text: "Apply the same rotation to the question structure")
                InfoRow(icon: "4.circle.fill", text: "Select the correct answer from the options")
            }
            .padding(16)
            .glassMorphism(cornerRadius: 14)
        }
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 20)
    }
}

// MARK: - Supporting Views

struct DifficultyCard: View {
    let difficulty: Difficulty
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: difficulty.icon)
                .font(.system(size: 22))
                .foregroundColor(difficulty.accentColor)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(difficulty.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)

                Text(difficulty.description)
                    .font(.system(size: 11))
                    .foregroundColor(NeoradusTheme.textTertiary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(difficulty.puzzleCount)")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(difficulty.accentColor)
                Text("puzzles")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(NeoradusTheme.textTertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? difficulty.accentColor.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isSelected ? difficulty.accentColor.opacity(0.5) : Color.white.opacity(0.08),
                    lineWidth: isSelected ? 1.5 : 1
                )
        )
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(NeoradusTheme.accentCyan)

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(NeoradusTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(NeoradusTheme.primaryGradient)

            Text(text)
                .font(.system(size: 13))
                .foregroundColor(NeoradusTheme.textSecondary)
        }
    }
}
