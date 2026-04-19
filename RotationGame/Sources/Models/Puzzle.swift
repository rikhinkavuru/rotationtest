// Puzzle.swift
// Neoradus Rotation Game

import Foundation

/// Represents a single rotation puzzle
struct Puzzle: Identifiable {
    let id = UUID()

    /// The reference structure shown before rotation
    let referenceStructure: BlockStructure

    /// The reference structure after the correct rotation is applied
    let rotatedReference: BlockStructure

    /// The question structure that the player must mentally rotate
    let questionStructure: BlockStructure

    /// The correct answer: the question structure after the same rotation
    let correctAnswer: BlockStructure

    /// All answer options (including the correct one)
    let options: [BlockStructure]

    /// The index of the correct answer in the options array
    let correctOptionIndex: Int

    /// The rotation that was applied
    let rotation: Rotation3D

    /// Difficulty level
    let difficulty: Difficulty
}

// MARK: - Puzzle Generator

struct PuzzleGenerator {
    /// Generate a puzzle for the given difficulty
    static func generate(difficulty: Difficulty) -> Puzzle {
        let structures = structuresForDifficulty(difficulty)
        let rotations = Rotation3D.rotationsForDifficulty(difficulty)
        let fallbackStructure = BlockStructure.beginnerStructures.first ?? BlockStructure(
            blocks: [Block(x: 0, y: 0, z: 0)],
            name: "Fallback"
        )

        // Pick two different structures
        let shuffledStructures = (structures.isEmpty ? [fallbackStructure] : structures).shuffled()
        let reference = shuffledStructures.first ?? fallbackStructure
        let question = shuffledStructures.count > 1 ? shuffledStructures[1] : reference

        // Pick a rotation
        let rotation = rotations.randomElement() ?? Rotation3D(steps: [.y])

        // Compute the correct rotated versions
        let rotatedRef = reference.rotated(by: rotation)
        let correctAnswer = question.rotated(by: rotation)

        // Generate wrong options
        let optionCount = difficulty.optionCount
        var options = [correctAnswer]

        let wrongRotations = rotations.filter { $0 != rotation }.shuffled()
        for wrongRotation in wrongRotations {
            if options.count >= optionCount { break }
            let wrongAnswer = question.rotated(by: wrongRotation)
            // Make sure it's visually different from existing options
            if !options.contains(where: { $0.blocks == wrongAnswer.blocks }) {
                options.append(wrongAnswer)
            }
        }

        // If we still need more options, generate with combined rotations
        var attempts = 0
        let maxAttempts = 64
        while options.count < optionCount && attempts < maxAttempts {
            attempts += 1
            let randomAxes = RotationAxis.allCases.shuffled()
            let extraRotation = Rotation3D(steps: Array(randomAxes.prefix(Int.random(in: 1...2))))
            let extraAnswer = question.rotated(by: extraRotation)
            if !options.contains(where: { $0.blocks == extraAnswer.blocks }) {
                options.append(extraAnswer)
            }
        }

        if options.count < optionCount {
            for candidate in BlockStructure.allStructures where options.count < optionCount {
                if !options.contains(where: { $0.blocks == candidate.blocks }) {
                    options.append(candidate)
                }
            }
        }

        while options.count < optionCount {
            options.append(options.last ?? correctAnswer)
        }

        // Shuffle options and find correct index
        let shuffledOptions = options.shuffled()
        guard let correctIndex = shuffledOptions.firstIndex(where: { $0.blocks == correctAnswer.blocks }) else {
            // Fallback: place correct answer at index 0
            var fallbackOptions = [correctAnswer] + shuffledOptions.filter { $0.blocks != correctAnswer.blocks }
            fallbackOptions = Array(fallbackOptions.prefix(optionCount))
            return Puzzle(
                referenceStructure: reference,
                rotatedReference: rotatedRef,
                questionStructure: question,
                correctAnswer: correctAnswer,
                options: fallbackOptions,
                correctOptionIndex: 0,
                rotation: rotation,
                difficulty: difficulty
            )
        }

        return Puzzle(
            referenceStructure: reference,
            rotatedReference: rotatedRef,
            questionStructure: question,
            correctAnswer: correctAnswer,
            options: shuffledOptions,
            correctOptionIndex: correctIndex,
            rotation: rotation,
            difficulty: difficulty
        )
    }

    /// Generate a full set of puzzles for a game session
    static func generateSession(difficulty: Difficulty) -> [Puzzle] {
        (0..<difficulty.puzzleCount).map { _ in generate(difficulty: difficulty) }
    }

    private static func structuresForDifficulty(_ difficulty: Difficulty) -> [BlockStructure] {
        switch difficulty {
        case .beginner:
            return BlockStructure.beginnerStructures
        case .intermediate:
            return BlockStructure.beginnerStructures + BlockStructure.intermediateStructures
        case .advanced:
            return BlockStructure.intermediateStructures + BlockStructure.advancedStructures
        case .expert:
            return BlockStructure.allStructures
        }
    }
}
