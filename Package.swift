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
            targets: ["EyesonSdk", "EyesonSdk_Screencast", "WebRTC"]
        ),
        .library(
            name: "EyesonSdk_Screencast",
            targets: ["EyesonSdk_Screencast"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "EyesonSdk",
            path: "Sources/EyesonSdk.xcframework"
        ),
        .binaryTarget(
            name: "EyesonSdk_Screencast",
            path: "Sources/EyesonSdk_Screencast.xcframework"
        ),
        .binaryTarget(
            name: "WebRTC",
            path: "Sources/WebRTC.xcframework"
        )
    ]
)
