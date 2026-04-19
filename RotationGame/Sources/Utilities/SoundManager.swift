// SoundManager.swift
// Neoradus Rotation Game

import AVFoundation
import SwiftUI

/// Manages haptic feedback and sound effects
class SoundManager {
    static let shared = SoundManager()

    private init() {}

    // MARK: - Haptic Feedback

    func playCorrectHaptic() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }

    func playIncorrectHaptic() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
    }

    func playSelectionHaptic() {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }

    func playImpactHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
}
