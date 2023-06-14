// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DisplayAlignment",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Display",
            targets: [
                "Display"
            ]
        ),
        .executable(
            name: "display-alignment",
            targets: [
                "DisplayAlignment"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.2"
        )
    ],
    targets: [
        .target(
            name: "Display"
        ),
        .executableTarget(
            name: "DisplayAlignment",
            dependencies: [
                .target(
                    name: "Display"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
    ]
)
