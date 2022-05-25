import XCTest
@testable import DynamicCodableKit

extension Int: DynamicDecodable {}
extension String: DynamicDecodable {}

enum DynamicBaseDataTypeCodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
    typealias Identified = Decodable
    case value

    static func context<Container: KeyedDecodingContainerProtocol>(
        forContainer container: Container
    ) throws -> DynamicDecodingContext<Identified> where Self == Container.Key {
        return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
    }
}

enum DynamicBaseDataTypeCollectionCodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
    typealias Identified = Decodable
    case values

    static func context<Container: KeyedDecodingContainerProtocol>(
        forContainer container: Container
    ) throws -> DynamicDecodingContext<Identified> where Self == Container.Key {
        return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
    }
}

struct VariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCodingKeys
    @DynamicDecodingWrapper<CodingKeys> var value: Decodable
}

struct OptionalVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCodingKeys
    @OptionalDynamicDecodingWrapper<CodingKeys> var value: Decodable?
}

struct StrictVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @StrictDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]
}

struct DefaultVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @DefaultValueDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]
}

struct LossyVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @LossyDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]
}
