// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "brew-serve",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .executable(name: "brew-serve", targets: ["brew-serve"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/JochenBe/Shell", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "brew-serve",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Shell"
            ]),
    ]
)
