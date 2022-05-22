# Using Default Value if Decoding Fails

Customize behavior if decoding fails by implementing ``DynamicDecodingDefaultValueProvider``.

## Overview

All the dynamic decoding scenario has specific property wrappers that accepts decoding a type implementing ``DynamicDecodingDefaultValueProvider``. The ``DynamicDecodingDefaultValueProvider/default`` value is used in the decoding failure scenario, due to invalid or corrupt data, instead of throwing error.


By default, library provides implementation for `Optional` types. If decoding `Optional` type fails ``DynamicDecodingDefaultValueProvider/default`` value `nil` is used.
```swift
extension Optional: DynamicDecodingDefaultValueProvider {
    public static var `default`: Self {
        return nil
    }
}
```

## Topics

### Protocols

- ``DynamicDecodingDefaultValueProvider``

### Property Wrappers

- ``DynamicDecodingDefaultValueWrapper``
- ``PathCodingKeyDefaultValueWrapper``
- ``DynamicDecodingDefaultValueContextBasedWrapper``

### Type Aliases

- ``OptionalDynamicDecodingWrapper``
- ``OptionalPathCodingKeyWrapper``
- ``OptionalDynamicDecodingContextBasedWrapper``