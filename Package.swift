// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Eyeson",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "EyesonSdk",
            targets: ["EyesonSdk", "Starscream", "SwiftyJSON", "WebRTC"])
    ],
    dependencies: [
        .package(url: "https://github.com/alexpiezo/WebRTC.git", .upToNextMajor(from: "1.1.31567"))
    ],
    targets: [
        .binaryTarget(
            name: "EyesonSdk",
            path: "Sources/EyesonSdk.xcframework"
        ),
        .binaryTarget(
            name: "Starscream",
            path: "Sources/Starscream.xcframework"
        ),
        .binaryTarget(
            name: "SwiftyJSON",
            path: "Sources/SwiftyJSON.xcframework"
        )
    ]
)
