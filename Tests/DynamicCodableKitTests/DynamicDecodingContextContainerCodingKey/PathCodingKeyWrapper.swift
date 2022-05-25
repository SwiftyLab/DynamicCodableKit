import XCTest
@testable import DynamicCodableKit

final class PathCodingKeyWrapperTests: XCTestCase {
    func testDecoding() throws {
        let data = containerCollectionDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(CommonPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
    }

    func testOptionalDecoding() throws {
        let data = containerCollectionDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalCommonPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertEqual($0.type, type) }
        }
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = containerCollectionDecode
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ThrowingCommonPostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let data = containerCollectionDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalTypeCommonPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        postPage.content.forEach { type, posts in
            XCTAssertEqual(posts.count, 3)
            posts.forEach { XCTAssertNil($0.type) }
        }
    }
}
