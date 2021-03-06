/// A property wrapper type that decodes dynamic value in a no throw approach based on
/// dynamic decoding context provided by ``DynamicDecodingContextCodingKey``.
///
/// This can be used as an alternative to ``DynamicDecodingWrapper``
/// where instead of throwing error when decoding fails,
/// ``DynamicDecodingDefaultValueProvider/default`` value provided by
/// ``DynamicDecodingDefaultValueProvider`` is used,
/// i.e. ``OptionalDynamicDecodingWrapper`` uses `nil` as default value in case of failure.
@frozen
@propertyWrapper
public struct DynamicDecodingDefaultValueWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey,
    Wrapped: DynamicDecodingDefaultValueProvider
>: PropertyWrapperCodable where Wrapped.Wrapped == ContextCodingKey.Identified {
    /// The underlying ``DynamicDecodingDefaultValueProvider``
    /// that wraps dynamic value value referenced.
    public var wrappedValue: Wrapped

    /// Creates new instance with an underlying dynamic wrapped value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial value with wrapped dynamic value.
    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) {
        guard
            let container = try? decoder.container(
                keyedBy: ContextCodingKey.self
            ),
            let value = try? ContextCodingKey.context(
                forContainer: container
            ).decodeFrom(decoder)
        else {
            self.wrappedValue = Wrapped.default
            return
        }
        self.wrappedValue = .init(value)
    }
}

/// Decodes a value of dynamic ``DynamicDecodingDefaultValueWrapper``
/// type for the given keyed container and coding key.
///
/// - Parameters:
///   - container: The keyed container to cdecode from.
///   - type: The type of value to decode.
///   - key: The coding key.
///
/// - Returns: A dynamic value wrapped in ``DynamicDecodingDefaultValueWrapper``
///            or a default value provided by ``DynamicDecodingDefaultValueProvider``
///            if decoding fails.
fileprivate func decode<Container, Wrapped>(
    from container: Container,
    ofType type: DynamicDecodingDefaultValueWrapper<
        Container.Key, Wrapped
    >.Type,
    forKey key: Container.Key
) -> DynamicDecodingDefaultValueWrapper<Container.Key, Wrapped>
where Container: KeyedDecodingContainerProtocol {
    typealias Key = Container.Key
    guard
        let context = try? Key.context(forContainer: container),
        let decoder = try? container.superDecoder(forKey: key),
        let value = try? context.decodeFrom(decoder)
    else {
        return DynamicDecodingDefaultValueWrapper(wrappedValue: .default)
    }
    return DynamicDecodingDefaultValueWrapper(wrappedValue: .init(value))
}

public extension KeyedDecodingContainer
where K: DynamicDecodingContextCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingDefaultValueWrapper``
    /// type for the given coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A dynamic value wrapped in ``DynamicDecodingDefaultValueWrapper``
    ///            or a default value provided by ``DynamicDecodingDefaultValueProvider``
    ///            if decoding fails.
    func decode<Wrapped>(
        _ type: DynamicDecodingDefaultValueWrapper<K, Wrapped>.Type,
        forKey key: K
    ) -> DynamicDecodingDefaultValueWrapper<K, Wrapped> {
        return DynamicCodableKit.decode(from: self, ofType: type, forKey: key)
    }
}

public extension KeyedDecodingContainerProtocol
where Key: DynamicDecodingContextCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingDefaultValueWrapper``
    /// type for the given coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A dynamic value wrapped in ``DynamicDecodingDefaultValueWrapper``
    ///            or a default value provided by ``DynamicDecodingDefaultValueProvider``
    ///            if decoding fails.
    func decode<Wrapped>(
        _ type: DynamicDecodingDefaultValueWrapper<Key, Wrapped>.Type,
        forKey key: Key
    ) -> DynamicDecodingDefaultValueWrapper<Key, Wrapped> {
        return DynamicCodableKit.decode(from: self, ofType: type, forKey: key)
    }
}

/// A property wrapper type that decodes optional dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey``.
///
/// `OptionalDynamicDecodingWrapper` is a type alias for
/// ``DynamicDecodingDefaultValueWrapper``,
/// with wrapped value as optional dynamic value. If decoding fails,
/// `nil` is used as underlying value instead of throwing error.
public typealias OptionalDynamicDecodingWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey
> = DynamicDecodingDefaultValueWrapper<
    ContextCodingKey,
    Optional<ContextCodingKey.Identified>
>
