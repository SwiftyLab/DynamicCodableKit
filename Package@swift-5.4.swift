// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "DynamicCodableKit",
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
        .testTarget(
            name: "DynamicCodableKitTests",
            dependencies: ["DynamicCodableKit"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
