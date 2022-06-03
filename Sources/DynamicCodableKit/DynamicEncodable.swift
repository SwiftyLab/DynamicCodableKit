/// A type that can be dynamically converted to external representation,
/// allowing dynamic encoding.
public protocol DynamicEncodable {
    /// Encodes dynamic value into the given encoder.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    func dynamicEncode(to encoder: Encoder) throws
}

public extension DynamicEncodable where Self: Encodable {
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    func dynamicEncode(to encoder: Encoder) throws {
        try self.encode(to: encoder)
    }
}

public extension DynamicEncodable where Self: Sequence {
    /// Encodes the dynamic elements of this sequence
    /// into the given encoder in an unkeyed container.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    func dynamicEncode(to encoder: Encoder) throws {
        switch self {
        case let value as Encodable:
            try value.encode(to: encoder)
        default:
            var container = encoder.unkeyedContainer()
            try self.forEach { element in
                switch element {
                case let value as DynamicEncodable:
                    try value.dynamicEncode(to: container.superEncoder())
                case let value as Encodable:
                    try value.encode(to: container.superEncoder())
                default:
                    break
                }
            }
        }
    }
}

extension Optional: DynamicEncodable {
    /// Encodes wrapped dynamic value or the arapped value into the given encoder.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func dynamicEncode(to encoder: Encoder) throws {
        switch self {
        case .some(let value as DynamicEncodable):
            try value.dynamicEncode(to: encoder)
        case .some(let value as Encodable):
            try value.encode(to: encoder)
        default:
            break
        }
    }
}

/// A type that can be dynamically converted to external representation,
/// based on key value pairs.
protocol KeyedDynamicEncodable {
    /// Encodes the dynamic contents of this dictionary
    /// into the given encoder in a keyed container of dictionary key type.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    func keyedEncode(to encoder: Encoder) throws
}

extension Dictionary: KeyedDynamicEncodable where Key: CodingKey {
    /// Encodes the dynamic contents of this dictionary
    /// into the given encoder in a keyed container of dictionary key type.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    func keyedEncode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try self.forEach { key, value in
            switch value {
            case let value as DynamicEncodable:
                try value.dynamicEncode(to: container.superEncoder(forKey: key))
            case let value as Encodable:
                try value.encode(to: container.superEncoder(forKey: key))
            default:
                break
            }
        }
    }
}

extension Dictionary: DynamicEncodable {
    /// Encodes the dynamic contents of this dictionary into the given encoder.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func dynamicEncode(to encoder: Encoder) throws {
        switch self {
        case let value as KeyedDynamicEncodable:
            try value.keyedEncode(to: encoder)
        case let value as Encodable:
            try value.encode(to: encoder)
        default:
            break
        }
    }
}

/// A property wrapper type that can convert itself into and out of an external representation.
///
/// Default implementation allows converting into external representation
/// by converting wrapped value.
protocol PropertyWrapperCodable: Codable {
    /// The type of value that is wrapped.
    associatedtype Wrapped
    /// The wrapped value.
    var wrappedValue: Wrapped { get }
}

extension PropertyWrapperCodable {
    /// Encodes wrapped value into the given encoder.
    ///
    /// If wrapped value isn't an `Encodable` type or fails to encode anything,
    /// encoder will encode an empty keyed container in its place.
    /// This function throws an error if any values are invalid for the given encoder’s format.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        switch wrappedValue {
        case let value as DynamicEncodable:
            try value.dynamicEncode(to: encoder)
        case let value as Encodable:
            try value.encode(to: encoder)
        default:
            break
        }
    }
}

/// A property wrapper type that can convert itself out of an external representation
/// depending on decoding path or info value.
///
/// The value itself doesn't have external representation
/// but can be associated with an external representation.
protocol PropertyWrapperDecodableEmptyCodable: PropertyWrapperCodable {}
extension PropertyWrapperDecodableEmptyCodable {
    /// Encodes an empty keyed container into the given encoder.
    ///
    /// - Parameters:
    ///   - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        // Do nothing
    }
}

extension Array: DynamicEncodable {}
extension ClosedRange: DynamicEncodable where Bound: Encodable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CollectionDifference: DynamicEncodable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CollectionDifference.Change: DynamicEncodable
where ChangeElement: Codable {}
extension ContiguousArray: DynamicEncodable {}
extension PartialRangeFrom: DynamicEncodable where Bound: Encodable {}
extension PartialRangeThrough: DynamicEncodable where Bound: Encodable {}
extension PartialRangeUpTo: DynamicEncodable where Bound: Encodable {}
extension Range: DynamicEncodable where Bound: Encodable {}
extension Set: DynamicEncodable {}

#if canImport(TabularData)
import TabularData
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension Column: DynamicEncodable {}
#endif

#if canImport(MusicKit)
import MusicKit
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension MusicCatalogResourceResponse: DynamicEncodable
where MusicItemType: Encodable {}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8, *)
extension MusicItemCollection: DynamicEncodable {}
#endif

#if canImport(Combine)
import Combine
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Record: DynamicEncodable where Output: Codable, Failure: Codable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Record.Recording: DynamicEncodable
where Output: Codable, Failure: Codable {}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Subscribers.Completion: DynamicEncodable where Failure: Encodable {}
#endif
