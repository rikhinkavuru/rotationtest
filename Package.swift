// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RotationGame",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "RotationGame",
            targets: ["RotationGame"]
        )
    ],
    targets: [
        .executableTarget(
            name: "RotationGame",
            path: "RotationGame/Sources"
        )
    ]
)
