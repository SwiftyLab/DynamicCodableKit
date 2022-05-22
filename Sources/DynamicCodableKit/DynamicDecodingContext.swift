/// Stores context for decoding a dynamic type or dynamic array.
///
/// After this struct has been initialized, you can decode dynamic
/// type by passing `Decoder` in ``decodeFrom``.
///
/// ```swift
/// let value: Base = context.decodeFrom(decoder)
/// ```
@frozen
public struct DynamicDecodingContext<Base> {
    internal typealias B = Base
    /// Decode `Base` type from `Decoder`.
    ///
    /// ```swift
    /// let value: Base = context.decodeFrom(decoder)
    /// ```
    ///
    /// - Parameter decoder: The `Decoder` to decode from.
    ///
    /// - Returns: The decoded `Base` type.
    ///
    /// - Throws: `DecodingError` if data invalid.
    public let decodeFrom: (Decoder) throws -> Base
    /// Decode `Array<Base>` type from `Decoder`.
    ///
    /// ```swift
    /// let value: Array<Base> = context.decodeArrayFrom(decoder)
    /// ```
    ///
    /// - Parameter decoder: The `Decoder` to decode from.
    ///
    /// - Returns: The decoded `Array<Base>` type.
    ///
    /// - Throws: `DecodingError` if any element data invalid.
    public let decodeArrayFrom: (Decoder) throws -> [Base]
    /// Decode valid data into `Array<Base>` type from `Decoder`,
    /// while ignoring invalid data.
    ///
    /// ```swift
    /// let value: Array<Base> = context.decodeLossyArrayFrom(decoder)
    /// ```
    ///
    /// - Parameter decoder: The `Decoder` to decode from.
    ///
    /// - Returns: The decoded `Array<Base>` type.
    public let decodeLossyArrayFrom: (Decoder) -> [Base]
}

// MARK: - Parse by type
public extension DynamicDecodingContext {
    /// Creates new context for decoding provided ``DynamicDecodable`` type or array.
    ///
    /// ```swift
    /// let context: DynamicDecodingContext<Decodable> = DynamicDecodingContext(decoding: Int.self)
    /// ```
    ///
    /// - Parameter type: The actual type to decode.
    init<Dynamic: DynamicDecodable>(decoding type: Dynamic.Type) {
        // MARK: - type decoding
        decodeFrom = { decoder in
            return try type.init(from: decoder).castAs(
                type: B.self,
                codingPath: decoder.codingPath
            )
        }
        // MARK: - array decoding
        decodeArrayFrom = { decoder in
            return try array(for: type).init(from: decoder).castAs(
                type: [B].self,
                codingPath: decoder.codingPath
            )
        }
        // MARK: - lossy array decoding
        decodeLossyArrayFrom = { decoder in
            guard
                var container = try? decoder.unkeyedContainer()
            else { return [] }

            var values: [B] = []
            while !container.isAtEnd {
                guard
                    let value = try? container.lossyDecode(
                        type
                    )?.castAs(
                        type: B.self,
                        codingPath: container.codingPath
                    )
                else { continue }
                values.append(value)
            }
            return values
        }
    }
}

// MARK: - Parse by type with fallback
public extension DynamicDecodingContext {
    /// Creates new context for decoding provided ``DynamicDecodable`` type or array.
    /// If decoding fails, decodes with provided fallback type.
    ///
    /// ```swift
    /// let context: DynamicDecodingContext<Decodable> = DynamicDecodingContext(decoding: Int.self, fallback: String.self)
    /// ```
    ///
    /// - Parameters:
    ///   - type: The primary type to decode.
    ///   - fallbackType: The fallback type to decode if primary type decoding fails.
    init<Original: DynamicDecodable, Fallback: DynamicDecodable>(
        decoding type: Original.Type,
        fallback fallbackType: Fallback.Type
    ) {
        // MARK: - type decoding
        decodeFrom = { decoder in
            do {
                return try type.init(from: decoder).castAs(
                    type: B.self,
                    codingPath: decoder.codingPath
                )
            }
            catch {
                return try fallbackType.init(from: decoder).castAs(
                    type: B.self,
                    codingPath: decoder.codingPath
                )
            }
        }
        // MARK: - array decoding
        decodeArrayFrom = { decoder in
            do {
                return try array(for: type).init(from: decoder).castAs(
                    type: [B].self,
                    codingPath: decoder.codingPath
                )
            }
            catch {
                return try array(for: fallbackType).init(from: decoder).castAs(
                    type: [B].self,
                    codingPath: decoder.codingPath
                )
            }
        }
        // MARK: - lossy array decoding
        decodeLossyArrayFrom = { decoder in
            guard
                var container = try? decoder.unkeyedContainer()
            else { return [] }

            var values: [B] = []
            while !container.isAtEnd {
                do {
                    let value = try container.decode(
                        type
                    ).castAs(
                        type: B.self,
                        codingPath: container.codingPath
                    )
                    values.append(value)
                } catch {
                    guard
                        let value = try? container.lossyDecode(
                            fallbackType
                        )?.castAs(
                            type: B.self,
                            codingPath: container.codingPath
                        )
                    else { continue }
                    values.append(value)
                }
            }
            return values
        }
    }
}

/// Gets array type of `Array<T>` for generic type `T`,
/// while ignoring invalid data.
///
/// ```swift
/// let arrType: Array<Int> = array(for: Int.self)
/// ```
///
/// - Parameter type: The type to get array type for.
///
/// - Returns: The array type `Array<T>` for  type `T`.
internal func array<T>(for type: T.Type) -> Array<T>.Type { Array<T>.self }
