// IsometricBlockView.swift
// Neoradus Rotation Game

import SwiftUI

/// Renders a 3D block structure in isometric projection
struct IsometricBlockView: View {
    let structure: BlockStructure
    var colorIndex: Int = 0
    var scale: CGFloat = 28
    var showAnimation: Bool = false
    @State private var animationProgress: CGFloat = 0

    private var colors: NeoradusTheme.BlockColors {
        NeoradusTheme.blockColors(forIndex: colorIndex)
    }

    var body: some View {
        GeometryReader { geometry in
            let offset = IsometricRenderer.centerOffset(
                for: structure,
                in: geometry.size,
                scale: scale
            )

            let sortedBlocks = IsometricRenderer.sortedForDrawing(Array(structure.blocks))

            Canvas { context, _ in
                for (index, block) in sortedBlocks.enumerated() {
                    let delay = showAnimation ? CGFloat(index) * 0.05 : 0
                    let blockOpacity = showAnimation ? min(1, max(0, (animationProgress - delay) / 0.3)) : 1.0

                    // Draw right face
                    if IsometricRenderer.isRightFaceVisible(block: block, in: structure.blocks) {
                        let vertices = IsometricRenderer.rightFace(at: block, scale: scale)
                            .map { CGPoint(x: $0.x + offset.x, y: $0.y + offset.y) }
                        drawFace(context: &context, vertices: vertices, color: colors.right, opacity: blockOpacity)
                    }

                    // Draw left face
                    if IsometricRenderer.isLeftFaceVisible(block: block, in: structure.blocks) {
                        let vertices = IsometricRenderer.leftFace(at: block, scale: scale)
                            .map { CGPoint(x: $0.x + offset.x, y: $0.y + offset.y) }
                        drawFace(context: &context, vertices: vertices, color: colors.left, opacity: blockOpacity)
                    }

                    // Draw top face
                    if IsometricRenderer.isTopFaceVisible(block: block, in: structure.blocks) {
                        let vertices = IsometricRenderer.topFace(at: block, scale: scale)
                            .map { CGPoint(x: $0.x + offset.x, y: $0.y + offset.y) }
                        drawFace(context: &context, vertices: vertices, color: colors.top, opacity: blockOpacity)
                    }
                }
            }
        }
        .onAppear {
            if showAnimation {
                withAnimation(.easeOut(duration: 0.8)) {
                    animationProgress = 1.0
                }
            }
        }
    }

    private func drawFace(
        context: inout GraphicsContext,
        vertices: [CGPoint],
        color: Color,
        opacity: CGFloat
    ) {
        guard vertices.count == 4 else { return }

        var path = Path()
        path.move(to: vertices[0])
        for i in 1..<vertices.count {
            path.addLine(to: vertices[i])
        }
        path.closeSubpath()

        // Fill
        context.fill(path, with: .color(color.opacity(Double(opacity))))

        // Stroke
        context.stroke(
            path,
            with: .color(Color.black.opacity(Double(opacity) * 0.3)),
            lineWidth: 0.8
        )

        // Subtle highlight on edges
        var highlightPath = Path()
        highlightPath.move(to: vertices[0])
        highlightPath.addLine(to: vertices[1])
        context.stroke(
            highlightPath,
            with: .color(Color.white.opacity(Double(opacity) * 0.1)),
            lineWidth: 0.5
        )
    }
}

// MARK: - Compact Isometric View for Options

struct CompactIsometricView: View {
    let structure: BlockStructure
    var colorIndex: Int = 0
    var isSelected: Bool = false
    var isCorrect: Bool? = nil

    var body: some View {
        ZStack {
            IsometricBlockView(
                structure: structure,
                colorIndex: colorIndex,
                scale: 18
            )
        }
        .frame(width: 120, height: 100)
        .glassMorphism(cornerRadius: 16, opacity: isSelected ? 0.2 : 0.1)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? NeoradusTheme.accentGreen : NeoradusTheme.accentPink
        }
        return NeoradusTheme.accentCyan
    }
}
