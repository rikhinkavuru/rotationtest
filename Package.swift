// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RotationGame",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "RotationGame",
            targets: ["RotationGame"]
        )
    ],
    targets: [
        .target(
            name: "RotationGame",
            path: "RotationGame/Sources"
        )
    ]
)
