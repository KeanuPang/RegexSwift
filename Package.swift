// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "RegexSwift",
    products: [
        .library(
            name: "RegexSwift",
            targets: ["RegexSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RegexSwift",
            dependencies: []),
        .executableTarget(
            name: "Demo",
            dependencies: ["RegexSwift"]),
        .testTarget(
            name: "RegexSwiftTests",
            dependencies: ["RegexSwift"]),
    ],
    swiftLanguageVersions: [.v5]
)
