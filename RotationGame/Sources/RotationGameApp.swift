// RotationGameApp.swift
// Neoradus Rotation Game
//
// A spatial reasoning puzzle game where players decode rotation transformations
// applied to 3D block structures and apply them to new structures.

import SwiftUI

@main
struct RotationGameApp: App {
    @StateObject private var gameManager = GameManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
                .preferredColorScheme(.dark)
        }
    }
}
