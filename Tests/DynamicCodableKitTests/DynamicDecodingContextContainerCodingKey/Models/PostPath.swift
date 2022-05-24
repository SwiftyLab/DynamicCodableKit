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
