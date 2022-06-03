/// A type that provides dynamic decoding context based on its value.
public protocol DynamicDecodingContextIdentifierKey: Decodable {
    /// The base type or base element type in case of collection, that will be decoded.
    associatedtype Identified
    /// The associated dynamic decoding context.
    var associatedContext: DynamicDecodingContext<Identified> { get }
}

/// A coding key type that decides dynamic decoding context based on its associated `KeyedDecodingContainer`.
public protocol DynamicDecodingContextCodingKey: CodingKey {
    /// The base type or base element type in case of collection, that will be decoded.
    associatedtype Identified
    /// Decides dynamic decoding context based on provided `KeyedDecodingContainer`.
    ///
    /// - Parameters:
    ///   - container: The `KeyedDecodingContainer` to analyse.
    ///
    /// - Returns: Dynamic decoding context to use on `container`.
    static func context<Container: KeyedDecodingContainerProtocol>(
        forContainer container: Container
    ) throws -> DynamicDecodingContext<Identified> where Container.Key == Self
}

/// A ``DynamicDecodingContextCodingKey`` type that decides dynamic decoding context based on its associated
/// ``DynamicDecodingContextIdentifierKey`` contained by ``identifierCodingKey``.
public protocol DynamicDecodingContextIdentifierCodingKey:
    DynamicDecodingContextCodingKey
{
    /// The ``DynamicDecodingContextIdentifierKey`` type that ``identifierCodingKey`` contains.
    associatedtype Identifier: DynamicDecodingContextIdentifierKey
    where Identifier.Identified == Identified

    /// The coding key value that contains ``DynamicDecodingContextIdentifierKey``.
    static var identifierCodingKey: Self { get }
}

public extension DynamicDecodingContextIdentifierCodingKey {
    /// Decides dynamic decoding context based on provided
    /// ``Identifier`` contained by ``identifierCodingKey``.
    ///
    /// Decodes ``Identifier`` key contained by ``identifierCodingKey``
    /// from provided `KeyedDecodingContainer`
    /// and exposes its ``DynamicDecodingContextIdentifierKey/associatedContext``.
    ///
    /// - Parameters:
    ///   - container: The `KeyedDecodingContainer` to analyse.
    ///
    /// - Returns: Dynamic decoding context to use on `container`.
    static func context<Container: KeyedDecodingContainerProtocol>(
        forContainer container: Container
    ) throws -> DynamicDecodingContext<Identified> where Container.Key == Self {
        return try container.decode(
            Identifier.self,
            forKey: Self.identifierCodingKey
        ).associatedContext
    }
}

// MARK: - Parse by DynamicDecodingContextCodingKey
public extension DynamicDecodingContext {
    /// Creates new context from ``DynamicDecodingContextCodingKey`` coding key.
    ///
    /// Uses ``DynamicDecodingContextCodingKey/context(forContainer:)``
    /// to decode dynamic type.
    ///
    /// ```swift
    /// let context: DynamicDecodingContext<Decodable> = DynamicDecodingContext(withKey: CodingKeys.self)
    /// ```
    ///
    /// - Parameters:
    ///   - key: The coding key type.
    init<Key: DynamicDecodingContextCodingKey>(
        withKey key: Key.Type
    ) where Key.Identified == Base {
        // MARK: - type decoding
        decodeFrom = { decoder in
            let container = try decoder.container(keyedBy: Key.self)
            return try Key.context(forContainer: container).decodeFrom(decoder)
        }
        // MARK: - array decoding
        decodeArrayFrom = { decoder in
            var values: [B] = []
            var container = try decoder.unkeyedContainer()
            while !container.isAtEnd {
                let iteratorDecoder = try container.superDecoder()
                let iteratorContainer = try iteratorDecoder.container(
                    keyedBy: Key.self
                )
                let value = try Key.context(
                    forContainer: iteratorContainer
                ).decodeFrom(iteratorDecoder)
                values.append(value)
            }
            return values
        }
        // MARK: - lossy array decoding
        decodeLossyArrayFrom = { decoder in
            guard
                var container = try? decoder.unkeyedContainer()
            else { return [] }

            var values: [B] = []
            while !container.isAtEnd {
                guard
                    let iteratorDecoder = try? container.superDecoder(),
                    let iteratorContainer = try? iteratorDecoder.container(
                        keyedBy: Key.self
                    ),
                    let value = try? Key.context(
                        forContainer: iteratorContainer
                    ).decodeFrom(iteratorDecoder)
                else { continue }
                values.append(value)
            }
            return values
        }
    }
}
