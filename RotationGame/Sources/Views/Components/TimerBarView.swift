// TimerBarView.swift
// Neoradus Rotation Game

import SwiftUI

struct TimerBarView: View {
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    let accentColor: Color

    private var progress: CGFloat {
        guard totalTime > 0 else { return 0 }
        return min(1, max(0, CGFloat(timeRemaining / totalTime)))
    }

    private var timerColor: Color {
        if progress > 0.5 {
            return accentColor
        } else if progress > 0.25 {
            return NeoradusTheme.accentOrange
        } else {
            return NeoradusTheme.accentPink
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(timerColor)

                Text(String(format: "%.1fs", timeRemaining))
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(timerColor)

                Spacer()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 4)

                    // Progress fill
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [timerColor, timerColor.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 4)
                        .animation(.linear(duration: 0.1), value: progress)

                    // Glow effect at the end of the bar
                    if progress > 0.02 {
                        Circle()
                            .fill(timerColor)
                            .frame(width: 8, height: 8)
                            .offset(x: geometry.size.width * progress - 4)
                            .neonGlow(color: timerColor, radius: 6)
                            .animation(.linear(duration: 0.1), value: progress)
                    }
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal)
    }
}

// MARK: - Score Display

struct ScoreDisplayView: View {
    let score: Int
    let streak: Int
    @State private var displayedScore: Int = 0

    var body: some View {
        HStack(spacing: 16) {
            // Score
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(NeoradusTheme.accentOrange)

                Text("\(displayedScore)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
            .onChange(of: score) { _, newValue in
                withAnimation(.spring(response: 0.3)) {
                    displayedScore = newValue
                }
            }
            .onAppear {
                displayedScore = score
            }

            // Streak
            if streak > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(NeoradusTheme.accentPink)

                    Text("×\(streak)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(NeoradusTheme.accentPink)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

// MARK: - Progress Indicator

struct PuzzleProgressView: View {
    let current: Int
    let total: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index < current ? accentColor : Color.white.opacity(0.15))
                    .frame(height: 3)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
        .padding(.horizontal)
    }
}
