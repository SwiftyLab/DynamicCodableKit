# ``DynamicCodableKit``

Access essential data types, property wrappers, and protocols to implement dynamic JSON decoding functionality working with Swift's sound type system.

## Overview

`DynamicCodableKit` framework provides a base layer of functionality to allow dynamic JSON data decoding. It does so by providing a ``DynamicDecodingContext`` that decodes a generic type, during initialization any concrete ``DynamicDecodable`` type can be provided to be decoded and then casted to the required generic type by using type's implemented ``DynamicDecodable/castAs(type:codingPath:)-4hwd``.


The data types, protocols, and property wrappers defined by `DynamicCodableKit` can be used to provide dynamic decoding functionality to swift's `Decodable` types.

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+ | 5.1 | CocoaPods, Carthage, Swift Package Manager, Manual | Fully Tested |
| Linux | 5.1 | Swift Package Manager | Fully Tested |
| Windows | 5.1 | Swift Package Manager | Not Tested but Supported |

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `DynamicCodableKit` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DynamicCodableKit'
```

Optionally, you can also use the pre-built XCFramework from the GitHub releases page by replacing `{version}` with the required version you want to use:

```ruby
pod 'DynamicCodableKit', :http => 'https://github.com/SwiftyLab/DynamicCodableKit/releases/download/v{version}/DynamicCodableKit-{version}.xcframework.zip'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate `DynamicCodableKit` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SwiftyLab/DynamicCodableKit"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DynamicCodableKit` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
.package(url: "https://github.com/SwiftyLab/DynamicCodableKit.git", from: "1.0.0"),
```

Optionally, you can also use the pre-built XCFramework from the GitHub releases page by replacing `{version}` and `{checksum}` with the required version and checksum of artifact you want to use:

```swift
.binaryTarget(name: "DynamicCodableKit", url: "https://github.com/SwiftyLab/DynamicCodableKit/releases/download/v{version}/DynamicCodableKit-{version}.xcframework.zip", checksum: "{checksum}"),
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate `DynamicCodableKit` into your project manually.

#### Git Submodule

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add `DynamicCodableKit` as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/SwiftyLab/DynamicCodableKit.git
  ```

- Open the new `DynamicCodableKit` folder, and drag the `DynamicCodableKit.xcodeproj` into the Project Navigator of your application's Xcode project or existing workspace.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `DynamicCodableKit.xcodeproj` in the Project Navigator and verify the deployment target satisfies that of your application target (should be less or equal).
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the `Targets` heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the `Frameworks and Libraries` section.
- You will see `DynamicCodableKit.xcodeproj` folder with `DynamicCodableKit.framework` nested inside.
- Select the `DynamicCodableKit.framework` and that's it!

  > The `DynamicCodableKit.framework` is automagically added as a target dependency, linked framework and embedded framework in build phase which is all you need to build on the simulator and a device.

#### XCFramework

You can also directly download the pre-built artifact from the GitHub releases page:

- Download the artifact from the GitHub releases page of the format `DynamicCodableKit-{version}.xcframework.zip` where `{version}` is the version you want to use.
- Extract the XCFramework from the archive, and drag the `DynamicCodableKit.xcframework` into the Project Navigator of your application's target folder in your Xcode project.
- Select `Copy items if needed` and that's it!

  > The `DynamicCodableKit.xcframework` is automagically added in the embedded `Frameworks and Libraries` section, an in turn the linked framework in build phase.

## Topics

### Common Scenarios

- <doc:TypeIdentifier>
- <doc:ContainerCodingKey>
- <doc:ContextProvider>

### Decoding Configurations

- <doc:CollectionDecoding>
- <doc:NoThrowDecoding>

