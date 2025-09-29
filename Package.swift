// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "PacePilot",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "PacePilotTest", targets: ["PacePilotTest"])
    ],
    targets: [
        .executableTarget(
            name: "PacePilotTest",
            dependencies: []
        )
    ]
)