/// A property wrapper type that exposes value of provided coding key type
/// from the path of coding keys taken to get to decoding this type.
@frozen
@propertyWrapper
public struct PathCodingKeyWrapper<
    Key: CodingKey
>: PropertyWrapperDecodableEmptyCodable {
    /// The underlying coding key value referenced.
    public var wrappedValue: Key

    /// Creates new instance with a coding key wrapped value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial coding key wrapped value.
    public init(wrappedValue: Key) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.valueNotFound` if coding key
    ///           of provided type not found in `decoder.codingPath`.
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try decoder.codingKeyFromPath(ofType: Key.self)
    }
}

public extension KeyedDecodingContainer {
    /// Decodes a value of the type ``PathCodingKeyWrapper``
    /// for the given `PathKey` coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``PathCodingKeyWrapper``
    ///            for the given `PathKey` coding key.
    func decode<PathKey: CodingKey>(
        _ type: PathCodingKeyWrapper<PathKey>.Type,
        forKey key: K
    ) throws -> PathCodingKeyWrapper<PathKey> {
        return try .init(
            wrappedValue: self.codingKeyFromPath(ofType: PathKey.self)
        )
    }
}

public extension KeyedDecodingContainerProtocol {
    /// Decodes a value of the type ``PathCodingKeyWrapper``
    /// for the given `PathKey` coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``PathCodingKeyWrapper``
    ///            for the given `PathKey` coding key.
    func decode<PathKey: CodingKey>(
        _ type: PathCodingKeyWrapper<PathKey>.Type,
        forKey key: Key
    ) throws -> PathCodingKeyWrapper<PathKey> {
        return try .init(
            wrappedValue: self.codingKeyFromPath(ofType: PathKey.self)
        )
    }
}
