import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingDictionaryWrapperTests: XCTestCase {
    func testDecoding() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(ThrowingKeyedPostPageCollection.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ThrowingKeyedPostPageCollection.self, from: data))
    }

    func testInvalidDataDecodingWithLossyConfig() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(LossyKeyedPostPageCollection.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            switch type {
            case .audio, .video:
                XCTAssertEqual(posts.count, 2)
            default:
                XCTAssertEqual(posts.count, 3)
            }
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
    }
}

struct ThrowingKeyedPostPageCollection: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}

struct LossyKeyedPostPageCollection: Decodable {
    let next: URL
    @LossyDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}
