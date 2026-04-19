// GameManager.swift
// Neoradus Rotation Game

import SwiftUI
import Combine

enum Screen {
    case menu
    case game
    case results
}

/// Central game state manager
class GameManager: ObservableObject {
    @Published var currentScreen: Screen = .menu
    @Published var selectedDifficulty: Difficulty = .beginner
    @Published var puzzles: [Puzzle] = []
    @Published var currentPuzzleIndex: Int = 0
    @Published var score: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var streak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var timeRemaining: TimeInterval = 30
    @Published var isTimerActive: Bool = false
    @Published var isPuzzleComplete: Bool = false
    @Published var lastAnswerCorrect: Bool? = nil
    @Published var totalTimeTaken: TimeInterval = 0
    @Published var showHint: Bool = false

    // Stats
    @Published var totalGamesPlayed: Int = 0
    @Published var lifetimeCorrect: Int = 0
    @Published var lifetimeBestStreak: Int = 0

    private var timer: AnyCancellable?
    private var puzzleStartTime: Date?

    var currentPuzzle: Puzzle? {
        guard currentPuzzleIndex < puzzles.count else { return nil }
        return puzzles[currentPuzzleIndex]
    }

    var progress: Double {
        guard !puzzles.isEmpty else { return 0 }
        return Double(currentPuzzleIndex) / Double(puzzles.count)
    }

    var isGameOver: Bool {
        currentPuzzleIndex >= puzzles.count
    }

    var accuracy: Double {
        guard currentPuzzleIndex > 0 else { return 0 }
        return Double(correctAnswers) / Double(currentPuzzleIndex) * 100
    }

    var averageTime: TimeInterval {
        guard currentPuzzleIndex > 0 else { return 0 }
        return totalTimeTaken / Double(currentPuzzleIndex)
    }

    // MARK: - Game Flow

    func startGame(difficulty: Difficulty) {
        selectedDifficulty = difficulty
        puzzles = PuzzleGenerator.generateSession(difficulty: difficulty)
        currentPuzzleIndex = 0
        score = 0
        correctAnswers = 0
        streak = 0
        bestStreak = 0
        totalTimeTaken = 0
        lastAnswerCorrect = nil
        showHint = false

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentScreen = .game
        }

        startPuzzleTimer()
    }

    func submitAnswer(optionIndex: Int) {
        guard let puzzle = currentPuzzle else { return }

        stopTimer()

        let timeTaken = puzzleStartTime.map { Date().timeIntervalSince($0) } ?? 0
        totalTimeTaken += timeTaken

        let isCorrect = optionIndex == puzzle.correctOptionIndex
        lastAnswerCorrect = isCorrect

        if isCorrect {
            correctAnswers += 1
            streak += 1
            bestStreak = max(bestStreak, streak)

            // Score calculation: base points + time bonus + streak bonus
            let basePoints = 100
            let timeBonus = max(0, Int((selectedDifficulty.timeLimit - timeTaken) * 5))
            let streakBonus = min(streak * 10, 50)
            score += basePoints + timeBonus + streakBonus
        } else {
            streak = 0
        }

        isPuzzleComplete = true

        // Auto-advance after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.advanceToNextPuzzle()
        }
    }

    func advanceToNextPuzzle() {
        isPuzzleComplete = false
        lastAnswerCorrect = nil
        showHint = false
        currentPuzzleIndex += 1

        if isGameOver {
            finishGame()
        } else {
            startPuzzleTimer()
        }
    }

    func toggleHint() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showHint.toggle()
        }
        // Penalty for using hint
        if showHint {
            score = max(0, score - 25)
        }
    }

    func skipPuzzle() {
        stopTimer()
        streak = 0
        isPuzzleComplete = false
        lastAnswerCorrect = nil
        showHint = false
        currentPuzzleIndex += 1

        if isGameOver {
            finishGame()
        } else {
            startPuzzleTimer()
        }
    }

    func returnToMenu() {
        stopTimer()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentScreen = .menu
        }
    }

    // MARK: - Timer

    private func startPuzzleTimer() {
        puzzleStartTime = Date()
        timeRemaining = selectedDifficulty.timeLimit
        isTimerActive = true

        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let elapsed = Date().timeIntervalSince(self.puzzleStartTime ?? Date())
                self.timeRemaining = max(0, self.selectedDifficulty.timeLimit - elapsed)

                if self.timeRemaining <= 0 {
                    self.handleTimeout()
                }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
        isTimerActive = false
    }

    private func handleTimeout() {
        stopTimer()
        streak = 0
        lastAnswerCorrect = false
        isPuzzleComplete = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.advanceToNextPuzzle()
        }
    }

    private func finishGame() {
        totalGamesPlayed += 1
        lifetimeCorrect += correctAnswers
        lifetimeBestStreak = max(lifetimeBestStreak, bestStreak)

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentScreen = .results
        }
    }
}
