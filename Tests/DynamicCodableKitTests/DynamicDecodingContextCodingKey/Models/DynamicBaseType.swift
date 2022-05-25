import XCTest
@testable import DynamicCodableKit

extension Int: DynamicDecodable {}
extension String: DynamicDecodable {}

struct VariableBaseDataTypeContainer: Decodable {
    @DynamicDecodingWrapper<CodingKeys> var value: Decodable

    enum CodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
        typealias Identified = Decodable
        case value

        static func context<Container: KeyedDecodingContainerProtocol>(
            forContainer container: Container
        ) throws -> DynamicDecodingContext<Identified> where CodingKeys == Container.Key {
            return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
        }
    }
}

struct OptionalVariableBaseDataTypeContainer: Decodable {
    @OptionalDynamicDecodingWrapper<CodingKeys> var value: Decodable?

    enum CodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
        typealias Identified = Decodable
        case value

        static func context<Container: KeyedDecodingContainerProtocol>(
            forContainer container: Container
        ) throws -> DynamicDecodingContext<Identified> where CodingKeys == Container.Key {
            return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
        }
    }
}

struct StrictVariableBaseDataTypeContainer: Decodable {
    @StrictDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    enum CodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
        typealias Identified = Decodable
        case values

        static func context<Container: KeyedDecodingContainerProtocol>(
            forContainer container: Container
        ) throws -> DynamicDecodingContext<Identified> where CodingKeys == Container.Key {
            return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
        }
    }
}

struct DefaultVariableBaseDataTypeContainer: Decodable {
    @DefaultValueDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    enum CodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
        typealias Identified = Decodable
        case values

        static func context<Container: KeyedDecodingContainerProtocol>(
            forContainer container: Container
        ) throws -> DynamicDecodingContext<Identified> where CodingKeys == Container.Key {
            return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
        }
    }
}

struct LossyVariableBaseDataTypeContainer: Decodable {
    @LossyDynamicDecodingArrayWrapper<CodingKeys> var values: [Decodable]

    enum CodingKeys: String, CodingKey, DynamicDecodingContextCodingKey {
        typealias Identified = Decodable
        case values

        static func context<Container: KeyedDecodingContainerProtocol>(
            forContainer container: Container
        ) throws -> DynamicDecodingContext<Identified> where CodingKeys == Container.Key {
            return DynamicDecodingContext(decoding: Int.self, fallback: String.self)
        }
    }
}
