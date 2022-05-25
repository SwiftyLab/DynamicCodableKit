# DynamicCodableKit

[![API Docs](http://img.shields.io/badge/Read_the-docs-2196f3.svg)](https://swiftylab.github.io/dynamic-codable-kit/documentation/dynamiccodablekit/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DynamicCodableKit.svg?label=CocoaPods&color=C90005)](https://badge.fury.io/co/DynamicCodableKit)
[![Swift Package Manager Compatible](https://img.shields.io/github/v/tag/SwiftyLab/dynamic-codable-kit?label=SPM&color=DE5D43)](https://badge.fury.io/gh/SwiftyLab%2Fdynamic-codable-kit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-DE5D43)
[![Platforms](https://img.shields.io/badge/Platforms-all-sucess)](https://img.shields.io/badge/Platforms-all-sucess)
[![CI/CD](https://github.com/SwiftyLab/dynamic-codable-kit/actions/workflows/main.yml/badge.svg?event=push)](https://github.com/SwiftyLab/dynamic-codable-kit/actions/workflows/main.yml)
[![CodeQL](https://github.com/SwiftyLab/dynamic-codable-kit/actions/workflows/codeql-analysis.yml/badge.svg?event=push)](https://github.com/SwiftyLab/dynamic-codable-kit/actions/workflows/codeql-analysis.yml)
[![codecov](https://codecov.io/gh/SwiftyLab/dynamic-codable-kit/branch/main/graph/badge.svg?token=QIM4SKWNCS)](https://codecov.io/gh/SwiftyLab/dynamic-codable-kit)

**DynamicCodableKit** helps you to implement dynamic JSON decoding within the constraints of Swift's sound type system by working on top of Swift's Codable implementations.

The data types, protocols, and property wrappers defined by **DynamicCodableKit** can be used to provide dynamic decoding functionality to swift's `Decodable` types.

## Features

- Decode dynamic type based on JSON keys.
- Decode dynamic type based on parent JSON key.
- Dynamically decode types with default value if decoding fails.
- Decode dynamic type array/set with option to ignore invalid elements.
- Decode dynamic data based on user actions.

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+ | 5.1 | [CocoaPods](#cocoapods), [Carthage](#carthage), [Swift Package Manager](#swift-package-manager) | Fully Tested |
| Linux | 5.1 | [Swift Package Manager](#swift-package-manager) | Fully Tested |
| Windows | 5.1 | [Swift Package Manager](#swift-package-manager) | Not Tested but Supported |

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `DynamicCodableKit` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DynamicCodableKit'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate `DynamicCodableKit` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SwiftyLab/dynamic-codable-kit"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DynamicCodableKit` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/SwiftyLab/dynamic-codable-kit.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

See the full [documentation](https://swiftylab.github.io/dynamic-codable-kit/documentation/dynamiccodablekit/) for API details and articles on sample scenarios.

## Contributing

If you wish to contribute a change, suggest any improvementse,
please review our [contribution guide](CONTRIBUTING.md),
check for open [issues](https://github.com/SwiftyLab/dynamic-codable-kit/issues), if it is already being worked upon
or open a [pull request](https://github.com/SwiftyLab/dynamic-codable-kit/pulls).

## License

`dynamic-codable-kit` is released under the MIT license. [See LICENSE](LICENSE) for details.