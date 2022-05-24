import XCTest
@testable import DynamicCodableKit

final class PathCodingKeyWrapperTests: XCTestCase {
    func testDecoding() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(CommonPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ThrowingCommonPostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalTypeCommonPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertNil($0.type) }
        }
    }
}

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
