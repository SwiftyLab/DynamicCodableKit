/// A property wrapper type that decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider``.
@frozen
@propertyWrapper
public struct DynamicDecodingCollectionContextBasedWrapper<
    Provider: DynamicDecodingContextProvider,
    DynamicCollection: SequenceInitializable,
    Config: DynamicDecodingCollectionConfigurationProvider
>: PropertyWrapperCodable
where DynamicCollection.Element == Provider.Identified {
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
        case .throw, .`default`:
            do {
                let context = try Provider.context(from: decoder)
                self.wrappedValue = try .init(context.decodeArrayFrom(decoder))
            } catch {
                if Config.failConfig == .throw { throw error }
                self.wrappedValue = .init()
            }
        case .lossy:
            guard
                let context = try? Provider.context(from: decoder)
            else {
                self.wrappedValue = .init()
                return
            }
            self.wrappedValue = .init(context.decodeLossyArrayFrom(decoder))
        }
    }
}

/// A property wrapper type that strictly decodes array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// throws error if decoding fails.
///
/// `StrictDynamicDecodingArrayContextBasedWrapper` is a type alias for
/// ``DynamicDecodingCollectionContextBasedWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingArrayContextBasedWrapper<
    Provider: DynamicDecodingContextProvider
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    Array<Provider.Identified>,
    StrictCollectionConfiguration
>

/// A property wrapper type that decodes array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// assigns default value if decoding fails.
///
/// `DefaultValueDynamicDecodingArrayContextBasedWrapper` is a type alias for
/// ``DynamicDecodingCollectionContextBasedWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``DefaultValueCollectionConfiguration``
public typealias DefaultValueDynamicDecodingArrayContextBasedWrapper<
    Provider: DynamicDecodingContextProvider
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    Array<Provider.Identified>,
    DefaultValueCollectionConfiguration
>

/// A property wrapper type that decodes valid data into array of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// ignores invalid data.
///
/// `LossyDynamicDecodingArrayContextBasedWrapper` is a type alias for
/// ``DynamicDecodingCollectionContextBasedWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingArrayContextBasedWrapper<
    Provider: DynamicDecodingContextProvider
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    Array<Provider.Identified>,
    LossyCollectionConfiguration
>

/// A property wrapper type that strictly decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// throws error if decoding fails.
///
/// `StrictDynamicDecodingCollectionContextBasedWrapper` is a type alias for
/// ``DynamicDecodingCollectionContextBasedWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingCollectionContextBasedWrapper<
    Provider: DynamicDecodingContextProvider,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    DynamicCollection,
    StrictCollectionConfiguration
> where DynamicCollection.Element == Provider.Identified

/// A property wrapper type that decodes collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// assigns default value if decoding fails.
///
/// `DefaultValueDynamicDecodingCollectionContextBasedWrapper` is a type
/// alias for ``DynamicDecodingCollectionContextBasedWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``DefaultValueCollectionConfiguration``
public typealias DefaultValueDynamicDecodingCollectionContextBasedWrapper<
    Provider: DynamicDecodingContextProvider,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    DynamicCollection,
    DefaultValueCollectionConfiguration
> where DynamicCollection.Element == Provider.Identified

/// A property wrapper type that decodes valid data into collection of dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider`` and
/// ignores invalid data.
///
/// `LossyDynamicDecodingCollectionContextBasedWrapper` is a type alias for
/// ``DynamicDecodingCollectionContextBasedWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingCollectionContextBasedWrapper<
    Provider: DynamicDecodingContextProvider,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionContextBasedWrapper<
    Provider,
    DynamicCollection,
    LossyCollectionConfiguration
> where DynamicCollection.Element == Provider.Identified
