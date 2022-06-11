/// A property wrapper type that decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey``.
@frozen
@propertyWrapper
public struct DynamicDecodingCollectionWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey,
    DynamicCollection: SequenceInitializable,
    Config: DynamicDecodingCollectionConfigurationProvider
>: PropertyWrapperCodable
where DynamicCollection.Element == ContextCodingKey.Identified {
    /// The underlying dynamic value collection referenced.
    public var wrappedValue: DynamicCollection

    /// Creates new instance with a dynamic collection value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial dynamic collection value.
    public init(wrappedValue: DynamicCollection) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if ``DynamicDecodingCollectionConfigurationProvider/failConfig``
    ///            is ``CollectionDecodeFailConfiguration/throw`` and data is invalid or corrupt.
    public init(from decoder: Decoder) throws {
        let context = DynamicDecodingContext(withKey: ContextCodingKey.self)
        switch Config.failConfig {
        case .throw, .`default`:
            do {
                self.wrappedValue = try .init(
                    context.decodeArrayFrom(decoder)
                )
            } catch {
                if Config.failConfig == .throw { throw error }
                self.wrappedValue = .init()
            }
        case .lossy:
            self.wrappedValue = .init(
                context.decodeLossyArrayFrom(decoder)
            )
        }
    }
}

/// Decodes a value of dynamic ``DynamicDecodingCollectionWrapper``
/// type for the given keyed container and coding key.
///
/// - Parameters:
///   - container: The keyed container to cdecode from.
///   - type: The type of value to decode.
///   - key: The coding key.
///
/// - Returns: A dynamic collection value wrapped in ``DynamicDecodingCollectionWrapper``.
///
/// - Throws: `DecodingError` if ``DynamicDecodingCollectionConfigurationProvider/failConfig``
///            is ``CollectionDecodeFailConfiguration/throw`` and data is invalid or corrupt.
fileprivate func decode<Container, DynamicCollection, Config>(
    from container: Container,
    ofType type: DynamicDecodingCollectionWrapper<
        Container.Key,
        DynamicCollection,
        Config
    >.Type,
    forKey key: Container.Key
) throws -> DynamicDecodingCollectionWrapper<
    Container.Key, DynamicCollection, Config
> where Container: KeyedDecodingContainerProtocol {
    typealias Key = Container.Key
    switch Config.failConfig {
    case .throw, .`default`:
        do {
            let decoder = try container.superDecoder(forKey: key)
            let value = try DynamicCollection.init(
                Key.context(forContainer: container).decodeArrayFrom(decoder)
            )
            return DynamicDecodingCollectionWrapper(wrappedValue: value)
        } catch {
            if Config.failConfig == .throw { throw error }
            return DynamicDecodingCollectionWrapper(wrappedValue: .init())
        }
    case .lossy:
        guard
            let decoder = try? container.superDecoder(forKey: key)
        else {
            return DynamicDecodingCollectionWrapper(wrappedValue: .init())
        }
        return DynamicDecodingCollectionWrapper(
            wrappedValue: .init(
                (try? Key.context(
                    forContainer: container
                ).decodeLossyArrayFrom(decoder)) ?? .init()
            )
        )
    }
}

public extension KeyedDecodingContainer
where K: DynamicDecodingContextCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingCollectionWrapper``
    /// type for the given coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A dynamic collection value wrapped in ``DynamicDecodingCollectionWrapper``.
    ///
    /// - Throws: `DecodingError` if ``DynamicDecodingCollectionConfigurationProvider/failConfig``
    ///            is ``CollectionDecodeFailConfiguration/throw`` and data is invalid or corrupt.
    func decode<DynamicCollection, Config>(
        _ type: DynamicDecodingCollectionWrapper<
            K, DynamicCollection, Config
        >.Type,
        forKey key: K
    ) throws -> DynamicDecodingCollectionWrapper<K, DynamicCollection, Config> {
        return try DynamicCodableKit.decode(
            from: self,
            ofType: type,
            forKey: key
        )
    }
}

public extension KeyedDecodingContainerProtocol
where Key: DynamicDecodingContextCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingCollectionWrapper``
    /// type for the given coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A dynamic collection value wrapped in ``DynamicDecodingCollectionWrapper``.
    ///
    /// - Throws: `DecodingError` if ``DynamicDecodingCollectionConfigurationProvider/failConfig``
    ///            is ``CollectionDecodeFailConfiguration/throw`` and data is invalid or corrupt.
    func decode<DynamicCollection, Config>(
        _ type: DynamicDecodingCollectionWrapper<
            Key, DynamicCollection, Config
        >.Type,
        forKey key: Key
    ) throws -> DynamicDecodingCollectionWrapper<Key, DynamicCollection, Config>
    {
        return try DynamicCodableKit.decode(
            from: self,
            ofType: type,
            forKey: key
        )
    }
}

/// A property wrapper type that strictly decodes array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// throws error if decoding fails.
///
/// `StrictDynamicDecodingArrayWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingArrayWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    Array<ContextCodingKey.Identified>,
    StrictCollectionConfiguration
>

/// A property wrapper type that decodes array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// assigns default value if decoding fails.
///
/// `DefaultValueDynamicDecodingArrayWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``DefaultValueCollectionConfiguration``
public typealias DefaultValueDynamicDecodingArrayWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    Array<ContextCodingKey.Identified>,
    DefaultValueCollectionConfiguration
>

/// A property wrapper type that decodes valid data into array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// ignores invalid data.
///
/// `LossyDynamicDecodingArrayWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingArrayWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    Array<ContextCodingKey.Identified>,
    LossyCollectionConfiguration
>

/// A property wrapper type that strictly decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// throws error if decoding fails.
///
/// `StrictDynamicDecodingCollectionWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingCollectionWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    DynamicCollection,
    StrictCollectionConfiguration
> where DynamicCollection.Element == ContextCodingKey.Identified

/// A property wrapper type that decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// assigns default value if decoding fails.
///
/// `DefaultValueDynamicDecodingCollectionWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``DefaultValueCollectionConfiguration``
public typealias DefaultValueDynamicDecodingCollectionWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    DynamicCollection,
    DefaultValueCollectionConfiguration
> where DynamicCollection.Element == ContextCodingKey.Identified

/// A property wrapper type that decodes valid data into collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey`` and
/// ignores invalid data.
///
/// `LossyDynamicDecodingCollectionWrapper` is a type alias for
/// ``DynamicDecodingCollectionWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingCollectionWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionWrapper<
    ContextCodingKey,
    DynamicCollection,
    LossyCollectionConfiguration
> where DynamicCollection.Element == ContextCodingKey.Identified
