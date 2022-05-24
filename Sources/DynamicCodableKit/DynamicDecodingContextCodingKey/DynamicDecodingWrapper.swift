/// A property wrapper type that decodes dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextCodingKey``.
@frozen
@propertyWrapper
public struct DynamicDecodingWrapper<
    ContextCodingKey: DynamicDecodingContextCodingKey
>: Decodable {
    /// The underlying dynamic value referenced.
    public var wrappedValue: ContextCodingKey.Identified

    /// Creates new instance with a dynamic value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial dynamic value.
    public init(wrappedValue: ContextCodingKey.Identified) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if data is invalid or corrupt.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContextCodingKey.self)
        self.wrappedValue = try ContextCodingKey.context(
            forContainer: container
        ).decodeFrom(decoder)
    }
}

public extension KeyedDecodingContainerProtocol
  where Key: DynamicDecodingContextCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingWrapper``
    /// type for the given coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A dynamic value wrapped in ``DynamicDecodingWrapper``.
    ///
    /// - Throws: `DecodingError` if data is invalid or corrupt.
    func decode(
        _ type: DynamicDecodingWrapper<Key>.Type,
        forKey key: Key
    ) throws -> DynamicDecodingWrapper<Key> {
        let context = try Key.context(forContainer: self)
        let decoder = try self.superDecoder(forKey: key)
        let value = try context.decodeFrom(decoder)
        return DynamicDecodingWrapper(wrappedValue: value)
    }
}
