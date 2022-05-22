/// A property wrapper type that decodes a dictionary value of ``DynamicDecodingContextContainerCodingKey`` coding key
/// and their dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` value.
@frozen
@propertyWrapper
public struct DynamicDecodingDictionaryWrapper<
    ContainerCodingKey: DynamicDecodingContextContainerCodingKey,
    Config: DynamicDecodingCollectionConfigurationProvider
>: Decodable where ContainerCodingKey: Hashable {
    /// The underlying dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` value.
    public var wrappedValue: [ContainerCodingKey: ContainerCodingKey.Contained]

    /// Creates new instance with an underlying dictionary value.
    ///
    /// - Parameters:
    ///   - wrappedValue: A dictionary ``DynamicDecodingContextContainerCodingKey`` key and
    ///                   dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` value.
    public init(wrappedValue: [ContainerCodingKey: ContainerCodingKey.Contained]) {
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
