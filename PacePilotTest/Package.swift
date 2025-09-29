// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "PacePilotTest",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "PacePilotTest"
        )
    ]
)