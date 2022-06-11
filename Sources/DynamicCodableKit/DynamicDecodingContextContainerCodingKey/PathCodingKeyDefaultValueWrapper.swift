/// A property wrapper type that exposes value of provided coding key type
/// in a no throw approach from the path of coding keys taken to get to decoding this type.
///
/// This can be used as an alternative to ``PathCodingKeyWrapper`` where instead of
/// throwing error when finding value of coding key type fails,
/// ``DynamicDecodingDefaultValueProvider/default`` value provided by
/// ``DynamicDecodingDefaultValueProvider`` is used,
/// i.e. ``OptionalPathCodingKeyWrapper`` uses `nil`
/// as default value in case of failure.
@frozen
@propertyWrapper
public struct PathCodingKeyDefaultValueWrapper<
    Value: DynamicDecodingDefaultValueProvider
>: PropertyWrapperDecodableEmptyCodable where Value.Wrapped: CodingKey {
    /// The underlying ``DynamicDecodingDefaultValueProvider``
    /// that wraps coding key value referenced.
    public var wrappedValue: Value

    /// Creates new instance with a value that has underlying coding key value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial value that has
    ///                   underlying coding key value.
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// If coding key of provided type not found in `decoder.codingPath`,
    /// default value is used for provided ``DynamicDecodingDefaultValueProvider``.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) {
        guard
            let value = decoder.codingKeyFromPath(ofType: Value.Wrapped.self)
        else { self.wrappedValue = .default; return }
        self.wrappedValue = .init(value)
    }
}

public extension KeyedDecodingContainer {
    /// Decodes a value of the type ``DynamicDecodingDefaultValueProvider``
    /// for the wrapped value type provided.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``DynamicDecodingDefaultValueProvider``
    ///            for the wrapped value type provided.
    func decode<Value: DynamicDecodingDefaultValueProvider>(
        _ type: PathCodingKeyDefaultValueWrapper<Value>.Type,
        forKey key: K
    ) -> PathCodingKeyDefaultValueWrapper<Value> {
        return self.decode(type)
    }
}

public extension KeyedDecodingContainerProtocol {
    /// Decodes a value of the type ``DynamicDecodingDefaultValueProvider`` from coding key path.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``DynamicDecodingDefaultValueProvider``
    ///            from coding key path.
    fileprivate func decode<Value>(
        _ type: PathCodingKeyDefaultValueWrapper<Value>.Type
    ) -> PathCodingKeyDefaultValueWrapper<Value> {
        guard
            let value = self.codingKeyFromPath(ofType: Value.Wrapped.self)
        else { return .init(wrappedValue: .default) }
        return .init(wrappedValue: .init(value))
    }
    /// Decodes a value of the type ``DynamicDecodingDefaultValueProvider``
    /// for the wrapped value type provided.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``DynamicDecodingDefaultValueProvider``
    ///            for the wrapped value type provided.
    func decode<Value: DynamicDecodingDefaultValueProvider>(
        _ type: PathCodingKeyDefaultValueWrapper<Value>.Type,
        forKey key: Key
    ) -> PathCodingKeyDefaultValueWrapper<Value> {
        return self.decode(type)
    }
}

/// A property wrapper type that exposes optional value of provided coding key type
/// from the path of coding keys taken to get to decoding this type.
///
/// `OptionalPathCodingKeyWrapper` is a type alias for ``PathCodingKeyDefaultValueWrapper``,
/// with `Value` generic type as `Optional<CodingKey>`. If coding key value of provided type is not found,
/// `nil` is used as underlying value instead of throwing error.
public typealias OptionalPathCodingKeyWrapper<Key: CodingKey> =
    PathCodingKeyDefaultValueWrapper<Optional<Key>>
