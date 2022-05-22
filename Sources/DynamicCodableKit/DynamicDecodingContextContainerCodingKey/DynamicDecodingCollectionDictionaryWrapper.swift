/// A property wrapper type that decodes a dictionary value of ``DynamicDecodingContextContainerCodingKey`` coding key
/// and their dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` collection value.
@frozen
@propertyWrapper
public struct DynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey,
    DynamicCollection: SequenceInitializable,
    Config: DynamicDecodingCollectionConfigurationProvider
>: Decodable where ContainerCodingKey: Hashable,
                   DynamicCollection.Element == ContainerCodingKey.Contained {
    /// The underlying dictionary of ``DynamicDecodingContextContainerCodingKey`` key and
    /// dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` collection value.
    public var wrappedValue: [ContainerCodingKey: DynamicCollection]

    /// Creates new instance with an underlying dictionary value.
    ///
    /// - Parameters:
    ///   - wrappedValue: A dictionary ``DynamicDecodingContextContainerCodingKey`` key and dynamic
    ///                   ``DynamicDecodingContextContainerCodingKey/Contained`` collection value.
    public init(wrappedValue: [ContainerCodingKey: DynamicCollection]) {
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
        case .throw:
            let container = try decoder.container(keyedBy: ContainerCodingKey.self)
            self.wrappedValue = try container.decode()
        default:
            guard
                let container = try? decoder.container(
                    keyedBy: ContainerCodingKey.self
                )
            else { self.wrappedValue = [:]; return }
            self.wrappedValue = container.lossyDecode()
        }
    }
}

/// A property wrapper type that strictly decodes a dictionary value of ``DynamicDecodingContextContainerCodingKey``
/// coding key and their dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` array value and
/// throws error if decoding fails.
///
/// `StrictDynamicDecodingArrayDictionaryWrapper` is a type alias for
/// ``DynamicDecodingCollectionDictionaryWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingArrayDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey
> = DynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey,
    Array<ContainerCodingKey.Contained>,
    StrictCollectionConfiguration
> where ContainerCodingKey: Hashable

/// A property wrapper type that decodes valid data into a dictionary value of
/// ``DynamicDecodingContextContainerCodingKey`` coding key and
/// their dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
/// array value while ignoring invalid data.
///
/// `LossyDynamicDecodingArrayDictionaryWrapper` is a type alias for
/// ``DynamicDecodingCollectionDictionaryWrapper``, with collection type
/// `Array` and ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingArrayDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey
> = DynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey,
    Array<ContainerCodingKey.Contained>,
    LossyCollectionConfiguration
> where ContainerCodingKey: Hashable

/// A property wrapper type that strictly decodes a dictionary value of ``DynamicDecodingContextContainerCodingKey``
/// coding key and their dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` collection value
/// and throws error if decoding fails.
///
/// `StrictDynamicDecodingCollectionDictionaryWrapper` is a type alias for
/// ``DynamicDecodingCollectionDictionaryWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``StrictCollectionConfiguration``
public typealias StrictDynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey,
    DynamicCollection,
    StrictCollectionConfiguration
> where ContainerCodingKey: Hashable,
        DynamicCollection.Element == ContainerCodingKey.Contained

/// A property wrapper type that decodes valid data into a dictionary value of
/// ``DynamicDecodingContextContainerCodingKey`` coding key and
/// their dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
/// collection value while ignoring invalid data.
///
/// `LossyDynamicDecodingCollectionDictionaryWrapper` is a type alias for
/// ``DynamicDecodingCollectionDictionaryWrapper``, with
/// ``DynamicDecodingCollectionConfigurationProvider`` as
/// ``LossyCollectionConfiguration``
public typealias LossyDynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey,
    DynamicCollection: SequenceInitializable
> = DynamicDecodingCollectionDictionaryWrapper<
    ContainerCodingKey,
    DynamicCollection,
    LossyCollectionConfiguration
> where ContainerCodingKey: Hashable,
        DynamicCollection.Element == ContainerCodingKey.Contained
