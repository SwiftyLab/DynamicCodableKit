/// A coding key type that can dynamically decode contained data.
public protocol DynamicDecodingContextContainerCodingKey: CodingKey {
    /// The base type or base element type in case of collection,
    /// for the data contained by this key.
    associatedtype Contained
    /// The dynamic decoding context for the data contained by this key.
    var containedContext: DynamicDecodingContext<Contained> { get }
}

public extension DynamicDecodingContextContainerCodingKey
  where Self: DynamicDecodingContextIdentifierKey,
        Self.Contained == Self.Identified {
    /// The associated dynamic decoding context.
    var containedContext: DynamicDecodingContext<Contained> { associatedContext }
}

public extension KeyedDecodingContainerProtocol
  where Key: DynamicDecodingContextContainerCodingKey {
    /// Decodes a value of dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// type for the given ``DynamicDecodingContextContainerCodingKey`` coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of the type ``DynamicDecodingContextContainerCodingKey/Contained``.
    func decode(
        _ type: Key.Contained.Type,
        forKey key: Key
    ) throws -> Key.Contained {
        let decoder = try self.superDecoder(forKey: key)
        return try key.containedContext.decodeFrom(decoder)
    }
    /// Decodes value of dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// collection type for the given ``DynamicDecodingContextContainerCodingKey`` coding key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of ``DynamicDecodingContextContainerCodingKey/Contained``
    ///            collection type.
    func decode<Value: SequenceInitializable>(
        _ type: Value.Type,
        forKey key: Key
    ) throws -> Value where Value.Element == Key.Contained {
        let decoder = try self.superDecoder(forKey: key)
        let items = try key.containedContext.decodeArrayFrom(decoder)
        return .init(items)
    }
    /// Decodes value of dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// collection type for the given ``DynamicDecodingContextContainerCodingKey`` coding key.
    /// Ignores invalid data instead of throwing error.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The coding key.
    ///
    /// - Returns: A value of ``DynamicDecodingContextContainerCodingKey/Contained``
    ///            collection type.
    func lossyDecode<Value: SequenceInitializable>(
        _ type: Value.Type,
        forKey key: Key
    ) -> Value where Value.Element == Key.Contained {
        guard
            let decoder = try? self.superDecoder(forKey: key)
        else { return .init() }
        let items = key.containedContext.decodeLossyArrayFrom(decoder)
        return .init(items)
    }
}

public extension KeyedDecodingContainerProtocol
  where Key: DynamicDecodingContextContainerCodingKey,
        Key: Hashable {
    /// Decodes a dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` value
    /// from the container.
    ///
    /// - Returns: A dictionary of keyed by ``DynamicDecodingContextContainerCodingKey``
    ///            and ``DynamicDecodingContextContainerCodingKey/Contained`` value.
    ///
    /// - Throws: `DecodingError` if invalid or corrupt data.
    func decode() throws -> [Key: Key.Contained] {
        return try self.allKeys.reduce(into: [:]) { values, key in
            let decoder = try self.superDecoder(forKey: key)
            values[key] = try key.containedContext.decodeFrom(decoder)
        }
    }
    /// Decodes a dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained`` value
    /// from the container. Ignores invalid data instead of throwing error.
    ///
    /// - Returns: A dictionary of keyed by ``DynamicDecodingContextContainerCodingKey``
    ///            and ``DynamicDecodingContextContainerCodingKey/Contained`` value.
    func lossyDecode() -> [Key: Key.Contained] {
        return self.allKeys.reduce(into: [:]) { values, key in
            guard
                let decoder = try? self.superDecoder(forKey: key),
                let value = try? key.containedContext.decodeFrom(decoder)
            else { return }
            values[key] = value
        }
    }
    /// Decodes a dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// collection value from the container.
    ///
    /// - Returns: A dictionary of keyed by ``DynamicDecodingContextContainerCodingKey``
    ///            and ``DynamicDecodingContextContainerCodingKey/Contained``
    ///            collection value.
    ///
    /// - Throws: `DecodingError` if invalid or corrupt data.
    func decode<Value: SequenceInitializable>() throws -> [Key: Value]
      where Value.Element == Key.Contained {
        return try self.allKeys.reduce(into: [:]) { values, key in
            let decoder = try self.superDecoder(forKey: key)
            let items = try key.containedContext.decodeArrayFrom(decoder)
            values[key] = .init(items)
        }
    }
    /// Decodes a dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// collection value from the container. Ignores keys with invalid data instead of throwing error.
    ///
    /// - Returns: A dictionary of keyed by ``DynamicDecodingContextContainerCodingKey``
    ///            and ``DynamicDecodingContextContainerCodingKey/Contained``
    ///            collection value.
    func decodeValidContainers<Value: SequenceInitializable>() -> [Key: Value]
      where Value.Element == Key.Contained {
        return self.allKeys.reduce(into: [:]) { values, key in
            guard
                let decoder = try? self.superDecoder(forKey: key),
                let items = try? key.containedContext.decodeArrayFrom(decoder),
                !items.isEmpty
            else { return }
            values[key] = .init(items)
        }
    }
    /// Decodes a dictionary of ``DynamicDecodingContextContainerCodingKey`` key
    /// and dynamic ``DynamicDecodingContextContainerCodingKey/Contained``
    /// collection value from the container. Ignores invalid data instead of throwing error.
    ///
    /// - Returns: A dictionary of keyed by ``DynamicDecodingContextContainerCodingKey``
    ///            and ``DynamicDecodingContextContainerCodingKey/Contained``
    ///            collection value.
    func lossyDecode<Value: SequenceInitializable>() -> [Key: Value]
      where Value.Element == Key.Contained {
        return self.allKeys.reduce(into: [:]) { values, key in
            guard
                let decoder = try? self.superDecoder(forKey: key),
                case let items = key.containedContext.decodeLossyArrayFrom(
                    decoder
                ),
                !items.isEmpty
            else { return }
            values[key] = .init(items)
        }
    }
}
