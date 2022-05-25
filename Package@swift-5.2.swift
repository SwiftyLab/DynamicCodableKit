// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "dynamic-codable-kit",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "DynamicCodableKit",
            targets: ["DynamicCodableKit"]
        ),
    ],
    targets: [
        .target(
            name: "DynamicCodableKit",
            dependencies: []
        ),
    ],
    swiftLanguageVersions: [.v5]
)
