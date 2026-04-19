// IsometricRenderer.swift
// Neoradus Rotation Game

import SwiftUI

/// Handles isometric projection of 3D block structures
enum IsometricRenderer {
    /// The isometric angle (30 degrees in radians)
    static let angle: CGFloat = .pi / 6

    /// Convert 3D block coordinates to 2D isometric screen position
    static func project(x: CGFloat, y: CGFloat, z: CGFloat, scale: CGFloat) -> CGPoint {
        let isoX = (x - z) * cos(angle) * scale
        let isoY = (x + z) * sin(angle) * scale - y * scale
        return CGPoint(x: isoX, y: isoY)
    }

    /// Get the vertices of the top face of an isometric cube
    static func topFace(at block: Block, scale: CGFloat) -> [CGPoint] {
        let bx = CGFloat(block.x)
        let by = CGFloat(block.y)
        let bz = CGFloat(block.z)

        return [
            project(x: bx, y: by + 1, z: bz, scale: scale),
            project(x: bx + 1, y: by + 1, z: bz, scale: scale),
            project(x: bx + 1, y: by + 1, z: bz + 1, scale: scale),
            project(x: bx, y: by + 1, z: bz + 1, scale: scale)
        ]
    }

    /// Get the vertices of the left face of an isometric cube
    static func leftFace(at block: Block, scale: CGFloat) -> [CGPoint] {
        let bx = CGFloat(block.x)
        let by = CGFloat(block.y)
        let bz = CGFloat(block.z)

        return [
            project(x: bx, y: by, z: bz, scale: scale),
            project(x: bx, y: by + 1, z: bz, scale: scale),
            project(x: bx, y: by + 1, z: bz + 1, scale: scale),
            project(x: bx, y: by, z: bz + 1, scale: scale)
        ]
    }

    /// Get the vertices of the right face of an isometric cube
    static func rightFace(at block: Block, scale: CGFloat) -> [CGPoint] {
        let bx = CGFloat(block.x)
        let by = CGFloat(block.y)
        let bz = CGFloat(block.z)

        return [
            project(x: bx, y: by, z: bz, scale: scale),
            project(x: bx + 1, y: by, z: bz, scale: scale),
            project(x: bx + 1, y: by + 1, z: bz, scale: scale),
            project(x: bx, y: by + 1, z: bz, scale: scale)
        ]
    }

    /// Calculate the draw order for blocks (painter's algorithm)
    /// Blocks farther from the camera should be drawn first
    static func sortedForDrawing(_ blocks: [Block]) -> [Block] {
        blocks.sorted { a, b in
            // Sort by distance from camera (back to front)
            let distA = a.x + a.z - a.y
            let distB = b.x + b.z - b.y
            if distA != distB { return distA < distB }
            // Tie-break: lower y first, then higher x+z
            if a.y != b.y { return a.y < b.y }
            return (a.x + a.z) < (b.x + b.z)
        }
    }

    /// Check if a face should be visible (not occluded by another block)
    static func isTopFaceVisible(block: Block, in structure: Set<Block>) -> Bool {
        !structure.contains(Block(x: block.x, y: block.y + 1, z: block.z))
    }

    static func isLeftFaceVisible(block: Block, in structure: Set<Block>) -> Bool {
        !structure.contains(Block(x: block.x, y: block.y, z: block.z + 1))
    }

    static func isRightFaceVisible(block: Block, in structure: Set<Block>) -> Bool {
        !structure.contains(Block(x: block.x + 1, y: block.y, z: block.z))
    }

    /// Calculate the center offset needed to center a structure in a given size
    static func centerOffset(for structure: BlockStructure, in size: CGSize, scale: CGFloat) -> CGPoint {
        let blocks = Array(structure.blocks)
        guard !blocks.isEmpty else { return .zero }

        let points = blocks.flatMap { block -> [CGPoint] in
            topFace(at: block, scale: scale) +
            leftFace(at: block, scale: scale) +
            rightFace(at: block, scale: scale)
        }

        guard let first = points.first else { return .zero }

        let (minX, maxX, minY, maxY) = points.reduce(
            (first.x, first.x, first.y, first.y)
        ) { result, point in
            (
                min(result.0, point.x),
                max(result.1, point.x),
                min(result.2, point.y),
                max(result.3, point.y)
            )
        }

        let structureWidth = maxX - minX
        let structureHeight = maxY - minY

        return CGPoint(
            x: (size.width - structureWidth) / 2 - minX,
            y: (size.height - structureHeight) / 2 - minY
        )
    }
}
