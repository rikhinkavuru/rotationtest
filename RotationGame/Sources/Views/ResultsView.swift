// ResultsView.swift
// Neoradus Rotation Game

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showContent = false
    @State private var scoreAnimated = false
    @State private var displayedScore: Int = 0
    @State private var ringProgress: CGFloat = 0

    private var grade: Grade {
        let accuracy = gameManager.accuracy
        if accuracy >= 90 { return .sRank }
        if accuracy >= 75 { return .aRank }
        if accuracy >= 60 { return .bRank }
        if accuracy >= 40 { return .cRank }
        return .dRank
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                // Title
                Text("SESSION COMPLETE")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .tracking(4)
                    .foregroundColor(NeoradusTheme.textTertiary)
                    .padding(.top, 20)
                    .opacity(showContent ? 1 : 0)

                // Grade ring
                gradeRing
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)

                // Score
                VStack(spacing: 4) {
                    Text("\(displayedScore)")
                        .font(.system(size: 48, weight: .ultraLight, design: .monospaced))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())

                    Text("TOTAL SCORE")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(NeoradusTheme.textTertiary)
                }
                .opacity(showContent ? 1 : 0)

                // Stats grid
                statsGrid
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)

                // Action buttons
                actionButtons
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }

            // Animate score counting
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 1.2)) {
                    ringProgress = CGFloat(gameManager.accuracy / 100)
                }
                animateScore()
            }
        }
    }

    // MARK: - Grade Ring

    private var gradeRing: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 8)
                .frame(width: 160, height: 160)

            // Progress ring
            Circle()
                .trim(from: 0, to: ringProgress)
                .stroke(
                    AngularGradient(
                        colors: [grade.color.opacity(0.3), grade.color, grade.color.opacity(0.8)],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 160, height: 160)
                .rotationEffect(.degrees(-90))
                .neonGlow(color: grade.color, radius: 6)

            // Grade letter
            VStack(spacing: 4) {
                Text(grade.letter)
                    .font(.system(size: 56, weight: .ultraLight))
                    .foregroundColor(grade.color)

                Text(grade.label)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(grade.color.opacity(0.7))
            }
        }
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ResultStatCard(
                    icon: "checkmark.circle",
                    value: "\(gameManager.correctAnswers)/\(gameManager.puzzles.count)",
                    label: "Correct",
                    color: NeoradusTheme.accentGreen
                )

                ResultStatCard(
                    icon: "percent",
                    value: String(format: "%.0f%%", gameManager.accuracy),
                    label: "Accuracy",
                    color: NeoradusTheme.accentCyan
                )
            }

            HStack(spacing: 12) {
                ResultStatCard(
                    icon: "flame",
                    value: "\(gameManager.bestStreak)",
                    label: "Best Streak",
                    color: NeoradusTheme.accentOrange
                )

                ResultStatCard(
                    icon: "timer",
                    value: String(format: "%.1fs", gameManager.averageTime),
                    label: "Avg Time",
                    color: NeoradusTheme.accentPurple
                )
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Retry button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                gameManager.startGame(difficulty: gameManager.selectedDifficulty)
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .semibold))

                    Text("RETRY SESSION")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [
                            gameManager.selectedDifficulty.accentColor,
                            gameManager.selectedDifficulty.accentColor.opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .neonGlow(color: gameManager.selectedDifficulty.accentColor, radius: 6)
            }

            // Menu button
            Button(action: {
                gameManager.returnToMenu()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "house")
                        .font(.system(size: 14, weight: .medium))

                    Text("MAIN MENU")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .tracking(2)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .glassMorphism(cornerRadius: 14)
            }
        }
    }

    // MARK: - Score Animation

    private func animateScore() {
        let target = gameManager.score
        let duration: Double = 1.0
        let steps = 30
        let interval = duration / Double(steps)
        let increment = Double(target) / Double(steps)

        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * interval) {
                withAnimation(.none) {
                    displayedScore = min(Int(Double(step) * increment), target)
                }
            }
        }
    }
}

// MARK: - Grade System

enum Grade {
    case sRank, aRank, bRank, cRank, dRank

    var letter: String {
        switch self {
        case .sRank: return "S"
        case .aRank: return "A"
        case .bRank: return "B"
        case .cRank: return "C"
        case .dRank: return "D"
        }
    }

    var label: String {
        switch self {
        case .sRank: return "EXCEPTIONAL"
        case .aRank: return "EXCELLENT"
        case .bRank: return "GOOD"
        case .cRank: return "ADEQUATE"
        case .dRank: return "NEEDS PRACTICE"
        }
    }

    var color: Color {
        switch self {
        case .sRank: return NeoradusTheme.accentCyan
        case .aRank: return NeoradusTheme.accentGreen
        case .bRank: return NeoradusTheme.accentPurple
        case .cRank: return NeoradusTheme.accentOrange
        case .dRank: return NeoradusTheme.accentPink
        }
    }
}

// MARK: - Result Stat Card

struct ResultStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(NeoradusTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassMorphism(cornerRadius: 14)
    }
}
