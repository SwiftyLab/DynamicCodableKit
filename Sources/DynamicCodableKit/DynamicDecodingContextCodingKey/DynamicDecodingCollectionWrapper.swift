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
        switch Config.failConfig {
        case .throw, .deafult:
            do {
                self.wrappedValue = try .init(
                    DynamicDecodingContext(
                        withKey: ContextCodingKey.self
                    ).decodeArrayFrom(decoder)
                )
            } catch {
                if Config.failConfig == .throw { throw error }
                self.wrappedValue = .init()
            }
        case .lossy:
            self.wrappedValue = .init(
                DynamicDecodingContext(
                    withKey: ContextCodingKey.self
                ).decodeLossyArrayFrom(decoder)
            )
        }
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
        switch Config.failConfig {
        case .throw, .deafult:
            do {
                let decoder = try self.superDecoder(forKey: key)
                let value = try DynamicCollection.init(
                    K.context(forContainer: self).decodeArrayFrom(decoder)
                )
                return DynamicDecodingCollectionWrapper(wrappedValue: value)
            } catch {
                if Config.failConfig == .throw { throw error }
                return DynamicDecodingCollectionWrapper(wrappedValue: .init())
            }
        case .lossy:
            guard
                let decoder = try? self.superDecoder(forKey: key)
            else {
                return DynamicDecodingCollectionWrapper(wrappedValue: .init())
            }
            return DynamicDecodingCollectionWrapper(
                wrappedValue: .init(
                    (try? K.context(
                        forContainer: self
                    ).decodeLossyArrayFrom(decoder)) ?? .init()
                )
            )
        }
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
        switch Config.failConfig {
        case .throw, .deafult:
            do {
                let decoder = try self.superDecoder(forKey: key)
                let value = try DynamicCollection.init(
                    Key.context(forContainer: self).decodeArrayFrom(decoder)
                )
                return DynamicDecodingCollectionWrapper(wrappedValue: value)
            } catch {
                if Config.failConfig == .throw { throw error }
                return DynamicDecodingCollectionWrapper(wrappedValue: .init())
            }
        case .lossy:
            guard
                let decoder = try? self.superDecoder(forKey: key)
            else {
                return DynamicDecodingCollectionWrapper(wrappedValue: .init())
            }
            return DynamicDecodingCollectionWrapper(
                wrappedValue: .init(
                    (try? Key.context(
                        forContainer: self
                    ).decodeLossyArrayFrom(decoder)) ?? .init()
                )
            )
        }
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
