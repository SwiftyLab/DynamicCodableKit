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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._value = try container.decode(DynamicDecodingWrapper<CodingKeys>.self, forKey: .value)
    }
}

struct OptionalVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCodingKeys
    @OptionalDynamicDecodingWrapper<CodingKeys> var value: Decodable?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._value = container.decode(OptionalDynamicDecodingWrapper<CodingKeys>.self, forKey: .value)
    }
}

struct StrictVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @StrictDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._values = try container.decode(StrictDynamicDecodingArrayWrapper<CodingKeys>.self, forKey: .values)
    }
}

struct DefaultVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @DefaultValueDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._values = try container.decode(DefaultValueDynamicDecodingArrayWrapper<CodingKeys>.self, forKey: .values)
    }
}

struct LossyVariableBaseDataTypeContainer: Decodable {
    typealias CodingKeys = DynamicBaseDataTypeCollectionCodingKeys
    @LossyDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._values = try container.decode(LossyDynamicDecodingArrayWrapper<CodingKeys>.self, forKey: .values)
    }
}
