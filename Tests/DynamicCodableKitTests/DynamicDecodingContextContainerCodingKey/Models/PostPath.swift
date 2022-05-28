import XCTest
@testable import DynamicCodableKit

struct CommonPost: Decodable {
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @PathCodingKeyWrapper var type: PostType
}

struct OptionalTypeCommonPost: Decodable {
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @OptionalPathCodingKeyWrapper var type: PostType?
}

struct CommonPostPage: Decodable {
    let next: URL
    @PostData var content: [PostType: [CommonPost]]
}

struct OptionalCommonPostPage: Decodable {
    let next: URL
    @OptionalPostData var content: [PostType: [OptionalTypeCommonPost]]
}

struct ThrowingCommonPostPage: Decodable {
    let next: URL
    var content: [String: [CommonPost]]
}

struct OptionalTypeCommonPostPage: Decodable {
    let next: URL
    var content: [String: [OptionalTypeCommonPost]]
}

@propertyWrapper
struct PostData: Decodable {
    public var wrappedValue: [PostType: [CommonPost]]

    public init(wrappedValue: [PostType: [CommonPost]]) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostType.self)
        self.wrappedValue = try container.allKeys.reduce(into: [:], { values, key in
            values[key] = try container.decode([CommonPost].self, forKey: key)
        })
    }
}

@propertyWrapper
struct OptionalPostData: Decodable {
    public var wrappedValue: [PostType: [OptionalTypeCommonPost]]

    public init(wrappedValue: [PostType: [OptionalTypeCommonPost]]) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostType.self)
        self.wrappedValue = try container.allKeys.reduce(into: [:], { values, key in
            values[key] = try container.decode([OptionalTypeCommonPost].self, forKey: key)
        })
    }
}

struct ContainedPathCodingKeyWrapper: Decodable {
    let text: [PathCodingKeyWrapper<CodingKeys>]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode([PathCodingKeyWrapper<CodingKeys>].self, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}

struct ContainedInvalidPathCodingKeyWrapper: Decodable {
    typealias Value = [PathCodingKeyWrapper<ContainedPathCodingKeyWrapper.CodingKeys>]
    let text: Value

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(Value.self, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}

struct ContainedOptionalPathCodingKeyWrapper: Decodable {
    typealias Value = [OptionalPathCodingKeyWrapper<CodingKeys>]
    let text: Value

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(Value.self, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}

struct ContainedInvalidOptionalPathCodingKeyWrapper: Decodable {
    typealias Value = [OptionalPathCodingKeyWrapper<ContainedOptionalPathCodingKeyWrapper.CodingKeys>]
    let text: [OptionalPathCodingKeyWrapper<ContainedOptionalPathCodingKeyWrapper.CodingKeys>]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(Value.self, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}
