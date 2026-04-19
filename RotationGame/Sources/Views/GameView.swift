// GameView.swift
// Neoradus Rotation Game

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedOptionIndex: Int? = nil
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar

            // Timer
            if gameManager.isTimerActive || gameManager.timeRemaining > 0 {
                TimerBarView(
                    timeRemaining: gameManager.timeRemaining,
                    totalTime: gameManager.selectedDifficulty.timeLimit,
                    accentColor: gameManager.selectedDifficulty.accentColor
                )
                .padding(.top, 8)
            }

            // Progress
            PuzzleProgressView(
                current: gameManager.currentPuzzleIndex,
                total: gameManager.puzzles.count,
                accentColor: gameManager.selectedDifficulty.accentColor
            )
            .padding(.top, 8)

            // Main puzzle content
            if let puzzle = gameManager.currentPuzzle {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Reference section
                        referenceSection(puzzle: puzzle)

                        // Rotation indicator
                        if gameManager.showHint {
                            VStack(spacing: 6) {
                                Text("ROTATION APPLIED")
                                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundColor(NeoradusTheme.textTertiary)

                                RotationIndicatorView(rotation: puzzle.rotation)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                        // Divider
                        HStack {
                            VStack { Divider().background(Color.white.opacity(0.1)) }
                            Text("APPLY TO")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .tracking(2)
                                .foregroundColor(NeoradusTheme.textTertiary)
                            VStack { Divider().background(Color.white.opacity(0.1)) }
                        }
                        .padding(.horizontal)

                        // Question structure
                        questionSection(puzzle: puzzle)

                        // Answer options
                        optionsSection(puzzle: puzzle)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 30)
                }
            }
        }
        .overlay {
            // Feedback overlay
            if let isCorrect = gameManager.lastAnswerCorrect, gameManager.isPuzzleComplete {
                FeedbackOverlay(isCorrect: isCorrect)
                    .transition(.scale.combined(with: .opacity))
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showContent = true
            }
        }
        .onChange(of: gameManager.currentPuzzleIndex) { _, _ in
            selectedOptionIndex = nil
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            // Back button
            Button(action: {
                gameManager.returnToMenu()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .glassMorphism(cornerRadius: 12, opacity: 0.15)
            }

            Spacer()

            ScoreDisplayView(
                score: gameManager.score,
                streak: gameManager.streak
            )

            Spacer()

            // Actions
            HStack(spacing: 8) {
                // Hint button
                Button(action: {
                    gameManager.toggleHint()
                }) {
                    Image(systemName: gameManager.showHint ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(gameManager.showHint ? NeoradusTheme.accentOrange : .white)
                        .frame(width: 36, height: 36)
                        .glassMorphism(cornerRadius: 10, opacity: 0.15)
                }

                // Skip button
                Button(action: {
                    gameManager.skipPuzzle()
                }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .glassMorphism(cornerRadius: 10, opacity: 0.15)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Reference Section

    private func referenceSection(puzzle: Puzzle) -> some View {
        VStack(spacing: 10) {
            Text("REFERENCE TRANSFORMATION")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(NeoradusTheme.textTertiary)

            HStack(spacing: 16) {
                // Before
                VStack(spacing: 6) {
                    Text("BEFORE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(NeoradusTheme.textTertiary)

                    IsometricBlockView(
                        structure: puzzle.referenceStructure,
                        colorIndex: 0,
                        scale: 22,
                        showAnimation: true
                    )
                    .frame(height: 110)
                    .frame(maxWidth: .infinity)
                    .glassMorphism(cornerRadius: 14)
                }

                // Arrow
                VStack(spacing: 4) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(NeoradusTheme.primaryGradient)

                    Image(systemName: "rotate.3d")
                        .font(.system(size: 14, weight: .ultraLight))
                        .foregroundColor(NeoradusTheme.textTertiary)
                }

                // After
                VStack(spacing: 6) {
                    Text("AFTER")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(NeoradusTheme.textTertiary)

                    IsometricBlockView(
                        structure: puzzle.rotatedReference,
                        colorIndex: 0,
                        scale: 22,
                        showAnimation: true
                    )
                    .frame(height: 110)
                    .frame(maxWidth: .infinity)
                    .glassMorphism(cornerRadius: 14)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Question Section

    private func questionSection(puzzle: Puzzle) -> some View {
        VStack(spacing: 8) {
            Text("QUESTION STRUCTURE")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(NeoradusTheme.textTertiary)

            IsometricBlockView(
                structure: puzzle.questionStructure,
                colorIndex: 1,
                scale: 28,
                showAnimation: true
            )
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .glassMorphism(cornerRadius: 16)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Options Section

    private func optionsSection(puzzle: Puzzle) -> some View {
        VStack(spacing: 10) {
            Text("SELECT THE CORRECT ROTATION")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(NeoradusTheme.textTertiary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
                ForEach(Array(puzzle.options.enumerated()), id: \.offset) { index, option in
                    OptionCard(
                        structure: option,
                        index: index,
                        isSelected: selectedOptionIndex == index,
                        isCorrect: gameManager.isPuzzleComplete
                            ? index == puzzle.correctOptionIndex
                            : nil,
                        showResult: gameManager.isPuzzleComplete,
                        colorIndex: 1
                    )
                    .onTapGesture {
                        guard !gameManager.isPuzzleComplete else { return }

                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()

                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedOptionIndex = index
                        }
                        gameManager.submitAnswer(optionIndex: index)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Option Card

struct OptionCard: View {
    let structure: BlockStructure
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool?
    let showResult: Bool
    var colorIndex: Int = 0

    private var borderColor: Color {
        if showResult {
            if isCorrect == true {
                return NeoradusTheme.accentGreen
            } else if isSelected && isCorrect == false {
                return NeoradusTheme.accentPink
            }
        }
        if isSelected { return NeoradusTheme.accentCyan }
        return Color.clear
    }

    private var bgOpacity: Double {
        if showResult && isCorrect == true { return 0.15 }
        if isSelected { return 0.1 }
        return 0.05
    }

    var body: some View {
        VStack(spacing: 6) {
            // Option label
            HStack {
                Text(optionLabel)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(NeoradusTheme.textTertiary)

                Spacer()

                if showResult {
                    if isCorrect == true {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(NeoradusTheme.accentGreen)
                            .transition(.scale)
                    } else if isSelected && isCorrect == false {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(NeoradusTheme.accentPink)
                            .transition(.scale)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)

            // Block rendering
            IsometricBlockView(
                structure: structure,
                colorIndex: colorIndex,
                scale: 18
            )
            .frame(height: 80)
        }
        .glassMorphism(cornerRadius: 14, opacity: bgOpacity)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: isSelected || (showResult && isCorrect == true) ? 2 : 0)
        )
        .scaleEffect(isSelected ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showResult)
    }

    private var optionLabel: String {
        let labels = ["A", "B", "C", "D", "E"]
        return index < labels.count ? labels[index] : "\(index + 1)"
    }
}
