// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "dynamic-codable-kit",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "DynamicCodableKit",
            targets: ["DynamicCodableKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "DynamicCodableKit",
            dependencies: []
        ),
        .testTarget(
            name: "DynamicCodableKitTests",
            dependencies: ["DynamicCodableKit"],
            resources: [
                .process("DynamicDecodingContextCodingKey/JSONs"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
