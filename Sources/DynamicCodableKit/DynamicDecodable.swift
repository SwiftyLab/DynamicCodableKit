/// A type that can be dynamically casted to multiple type,
/// allowing dynamic decoding.
public protocol DynamicDecodable: Decodable {
    /// Cast self as generic  type `T`.
    ///
    /// - Parameters:
    ///   - type: The type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as type `T`.
    ///
    /// - Throws: `DecodingError.typeMismatch` if casting fails.
    func castAs<T>(type: T.Type, codingPath: [CodingKey]) throws -> T
    /// Cast self as optional type `T` or initialize `T` with `nil` value.
    ///
    /// - Parameters:
    ///   - type: The optional type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as optional type `T`.
    func castAs<T: ExpressibleByNilLiteral>(
        type: T.Type,
        codingPath: [CodingKey]
    ) -> T
    /// Cast self as collection type `T`.
    ///
    /// - Parameters:
    ///   - type: The collection type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as collection type `T`.
    ///
    /// - Throws: `DecodingError.typeMismatch` if casting fails.
    func castAs<T: SequenceInitializable>(
        type: T.Type,
        codingPath: [CodingKey]
    ) throws -> T
}

public extension DynamicDecodable {
    /// Cast self as generic  type `T`.
    ///
    /// Tries dynamically casting `self` to `T`,
    /// throws error if instance can not be converted to destination type `T`.
    ///
    /// - Parameters:
    ///   - type: The type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as type `T`.
    ///
    /// - Throws: `DecodingError.typeMismatch` if casting fails.
    func castAs<T>(type: T.Type, codingPath: [CodingKey]) throws -> T {
        switch self {
        case let value as T:
            return value
        default:
            throw DecodingError.typeMismatch(T.self, codingPath: codingPath)
        }
    }
    /// Cast self as optional type `T` or initialize `T` with `nil` value.
    ///
    /// Tries dynamically casting `self` to optional type `T`,
    /// initializes type `T` with `nil` if instance can not be converted to destination type `T`.
    ///
    /// - Parameters:
    ///   - type: The optional type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as optional type `T`.
    func castAs<T: ExpressibleByNilLiteral>(
        type: T.Type,
        codingPath: [CodingKey]
    ) -> T {
        return self as? T ?? nil
    }
    /// Cast self as collection type `T`.
    ///
    /// First tries dynamically casting `self` to collection type `T`,
    /// falls back to dynamically casting each element
    /// to provided collection element type using ``castAs(type:codingPath:)-4hwd``.
    /// Throws error if both casting approaches fail.
    ///
    /// - Parameters:
    ///   - type: The collection type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as collection type `T`.
    ///
    /// - Throws: `DecodingError.typeMismatch` if casting fails.
    func castAs<T: SequenceInitializable>(
        type: T.Type,
        codingPath: [CodingKey]
    ) throws -> T {
        switch self {
        case let value as T:
            return value
        case let value as T.Element:
            return .init([value])
        default:
            throw DecodingError.typeMismatch(T.self, codingPath: codingPath)
        }
    }
}

public extension DynamicDecodable
where
    Self: Sequence,
    Element: DynamicDecodable
{
    /// Cast self as collection type `T`.
    ///
    /// First tries dynamically casting `self` to collection type `T`,
    /// falls back to dynamically casting `self` to collection element type
    /// and returns a collection with single element if succeeds.
    /// Throws error if both casting approaches fail.
    ///
    /// - Parameters:
    ///   - type: The collection type to cast as.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: Self as collection type `T`.
    ///
    /// - Throws: `DecodingError.typeMismatch` if casting fails.
    func castAs<T: SequenceInitializable>(
        type: T.Type,
        codingPath: [CodingKey]
    ) throws -> T {
        switch self {
        case let value as T:
            return value
        default:
            let values = try self.map {
                try $0.castAs(type: T.Element.self, codingPath: codingPath)
            }
            return T.init(values)
        }
    }
}

extension Optional: DynamicDecodable where Wrapped: DynamicDecodable {}
extension Array: DynamicDecodable where Element: DynamicDecodable {}
extension ClosedRange: DynamicDecodable where Bound: Decodable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CollectionDifference: DynamicDecodable where ChangeElement: Codable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CollectionDifference.Change: DynamicDecodable
where ChangeElement: Codable {}
extension ContiguousArray: DynamicDecodable where Element: Decodable {}
extension PartialRangeFrom: DynamicDecodable where Bound: Decodable {}
extension PartialRangeThrough: DynamicDecodable where Bound: Decodable {}
extension PartialRangeUpTo: DynamicDecodable where Bound: Decodable {}
extension Range: DynamicDecodable where Bound: Decodable {}
extension Set: DynamicDecodable where Element: DynamicDecodable {}

#if canImport(TabularData)
import TabularData
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension Column: DynamicDecodable where WrappedElement: Decodable {}
#endif

#if canImport(MusicKit)
import MusicKit
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension MusicCatalogResourceResponse: DynamicDecodable
where MusicItemType: Decodable {}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension MusicItemCollection: DynamicDecodable
where MusicItemType: Decodable {}
#endif

#if canImport(Combine)
import Combine
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Record: DynamicDecodable where Output: Codable, Failure: Codable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Record.Recording: DynamicDecodable
where Output: Codable, Failure: Codable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Subscribers.Completion: DynamicDecodable where Failure: Decodable {}
#endif

/// A type that can be dynamically casted to multiple type and can be dynamically converted to external representation,
/// allowing dynamic decoding and encoding
///
/// `DynamicCodable` is a type alias for the ``DynamicDecodable``, ``DynamicEncodable``
/// and `Encodable` protocols.
public typealias DynamicCodable = DynamicDecodable & DynamicEncodable & Codable
