// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VisionTextArc",
    platforms: [
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VisionTextArc",
            targets: ["VisionTextArc"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Dave-Ed-Cast/VisionTextArc.git", from: "1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "VisionTextArc",
            dependencies: ["VisionTextArc"],
            path: "Sources"),
        .testTarget(
            name: "VisionTextArcTests",
            dependencies: ["VisionTextArc"]
        ),
    ]
)
