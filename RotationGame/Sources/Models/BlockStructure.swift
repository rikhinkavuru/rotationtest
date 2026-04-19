// BlockStructure.swift
// Neoradus Rotation Game

import Foundation

/// Represents a single block position in 3D space
struct Block: Hashable, Codable {
    let x: Int
    let y: Int
    let z: Int

    /// Apply a rotation transformation to this block
    func rotated(by rotation: Rotation3D) -> Block {
        var result = self
        for axis in rotation.steps {
            result = result.rotated90(around: axis)
        }
        return result
    }

    /// Rotate 90 degrees around a single axis
    private func rotated90(around axis: RotationAxis) -> Block {
        switch axis {
        case .x:
            return Block(x: x, y: -z, z: y)
        case .negX:
            return Block(x: x, y: z, z: -y)
        case .y:
            return Block(x: z, y: y, z: -x)
        case .negY:
            return Block(x: -z, y: y, z: x)
        case .z:
            return Block(x: -y, y: x, z: z)
        case .negZ:
            return Block(x: y, y: -x, z: z)
        }
    }
}

/// A 3D structure composed of multiple blocks
struct BlockStructure: Hashable, Codable {
    let blocks: Set<Block>
    let name: String

    /// Apply a rotation to the entire structure and normalize positions
    func rotated(by rotation: Rotation3D) -> BlockStructure {
        let rotatedBlocks = blocks.map { $0.rotated(by: rotation) }
        return BlockStructure(blocks: Set(rotatedBlocks), name: name).normalized()
    }

    /// Normalize the structure so minimum coordinates are at origin
    func normalized() -> BlockStructure {
        guard !blocks.isEmpty else { return self }
        let minX = blocks.map(\.x).min()!
        let minY = blocks.map(\.y).min()!
        let minZ = blocks.map(\.z).min()!
        let shifted = blocks.map {
            Block(x: $0.x - minX, y: $0.y - minY, z: $0.z - minZ)
        }
        return BlockStructure(blocks: Set(shifted), name: name)
    }

    /// Get the bounding box dimensions
    var dimensions: (width: Int, height: Int, depth: Int) {
        guard !blocks.isEmpty else { return (0, 0, 0) }
        let maxX = blocks.map(\.x).max()!
        let maxY = blocks.map(\.y).max()!
        let maxZ = blocks.map(\.z).max()!
        return (maxX + 1, maxY + 1, maxZ + 1)
    }
}

// MARK: - Predefined Structures

extension BlockStructure {
    /// L-Shape structure
    static let lShape = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 2, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0)
        ],
        name: "L-Shape"
    )

    /// T-Shape structure
    static let tShape = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 2, y: 0, z: 0),
            Block(x: 1, y: 1, z: 0)
        ],
        name: "T-Shape"
    )

    /// 3D Corner structure
    static let corner3D = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0),
            Block(x: 0, y: 0, z: 1)
        ],
        name: "3D Corner"
    )

    /// Tower structure
    static let tower = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0),
            Block(x: 0, y: 2, z: 0),
            Block(x: 1, y: 0, z: 0)
        ],
        name: "Tower"
    )

    /// Zigzag structure
    static let zigzag = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 1, y: 1, z: 0),
            Block(x: 2, y: 1, z: 0)
        ],
        name: "Zigzag"
    )

    /// 3D Step structure
    static let step3D = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 1, y: 1, z: 0),
            Block(x: 1, y: 1, z: 1)
        ],
        name: "3D Step"
    )

    /// Cross structure
    static let cross = BlockStructure(
        blocks: [
            Block(x: 1, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0),
            Block(x: 1, y: 1, z: 0),
            Block(x: 2, y: 1, z: 0),
            Block(x: 1, y: 2, z: 0)
        ],
        name: "Cross"
    )

    /// 3D Bridge structure
    static let bridge3D = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 2, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0),
            Block(x: 1, y: 1, z: 0),
            Block(x: 2, y: 1, z: 0)
        ],
        name: "3D Bridge"
    )

    /// Spiral structure
    static let spiral = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 1, y: 0, z: 1),
            Block(x: 0, y: 0, z: 1),
            Block(x: 0, y: 1, z: 1),
            Block(x: 0, y: 1, z: 0)
        ],
        name: "Spiral"
    )

    /// Complex 3D structure
    static let complex3D = BlockStructure(
        blocks: [
            Block(x: 0, y: 0, z: 0),
            Block(x: 1, y: 0, z: 0),
            Block(x: 0, y: 1, z: 0),
            Block(x: 0, y: 0, z: 1),
            Block(x: 1, y: 1, z: 0),
            Block(x: 1, y: 0, z: 1)
        ],
        name: "Complex 3D"
    )

    /// All available structures grouped by complexity
    static let beginnerStructures: [BlockStructure] = [lShape, tShape, zigzag, tower]
    static let intermediateStructures: [BlockStructure] = [corner3D, step3D, cross, bridge3D]
    static let advancedStructures: [BlockStructure] = [spiral, complex3D]

    static let allStructures: [BlockStructure] = beginnerStructures + intermediateStructures + advancedStructures
}
