// swift-tools-version: 5.5

import PackageDescription

let dependencies: [Package.Dependency]
#if compiler(>=5.6)
dependencies = [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/yonaskolb/Mint.git", from: "0.15.0"),
]
#else
dependencies = [
    .package(url: "https://github.com/yonaskolb/Mint.git", from: "0.15.0"),
]
#endif

let package = Package(
    name: "DynamicCodableKit",
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
    dependencies: dependencies,
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
