import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingCollectionDictionaryWrapperTests: XCTestCase {
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

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let url = Bundle.module.url(forResource: "container-collection-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(DefaultValueKeyedPostPageCollection.self, from: data)
        XCTAssertEqual(postPage.content.count, 2)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
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
