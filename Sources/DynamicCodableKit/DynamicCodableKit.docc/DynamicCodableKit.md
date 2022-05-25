# ``DynamicCodableKit``

Access essential data types, property wrappers, and protocols to implement dynamic JSON decoding functionality working with Swift's sound type system.

## Overview

`DynamicCodableKit` framework provides a base layer of functionality to allow dynamic JSON data decoding. It does so by providing a ``DynamicDecodingContext`` that decodes a generic type, during initialization any concrete ``DynamicDecodable`` type can be provided to be decoded and then casted to the required generic type by using type's implemented ``DynamicDecodable/castAs(type:codingPath:)-4hwd``.


The data types, protocols, and property wrappers defined by `DynamicCodableKit` can be used to provide dynamic decoding functionality to swift's `Decodable` types.

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+ | 5.1 | CocoaPods, Carthage, Swift Package Manager | Fully Tested |
| Linux | 5.1 | Swift Package Manager | Fully Tested |
| Windows | 5.1 | Swift Package Manager | Not Tested but Supported |

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

## Topics

### Common Scenarios

- <doc:TypeIdentifier>
- <doc:ContainerCodingKey>
- <doc:ContextProvider>

### Decoding Configurations

- <doc:CollectionDecoding>
- <doc:NoThrowDecoding>

