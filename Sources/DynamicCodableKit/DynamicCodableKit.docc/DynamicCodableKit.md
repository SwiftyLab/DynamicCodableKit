# ``DynamicCodableKit``

Access essential data types, property wrappers, and protocols to implement dynamic JSON decoding functionality working with Swift's sound type system.

## Overview

`DynamicCodableKit` framework provides a base layer of functionality to allow dynamic JSON data decoding. It does so by providing a ``DynamicDecodingContext`` that decodes a generic type, during initialization any concrete ``DynamicDecodable`` type can be provided to be decoded and then casted to the required generic type by using type's implemented ``DynamicDecodable/castAs(type:codingPath:)-4hwd``.


The data types, protocols, and property wrappers defined by `DynamicCodableKit` can be used to provide dynamic decoding functionality to swift's `Decodable` types.

## Topics

### Common Scenarios

- <doc:TypeIdentifier>
- <doc:ContainerCodingKey>
- <doc:ContextProvider>

### Decoding Configurations

- <doc:CollectionDecoding>
- <doc:NoThrowDecoding>

