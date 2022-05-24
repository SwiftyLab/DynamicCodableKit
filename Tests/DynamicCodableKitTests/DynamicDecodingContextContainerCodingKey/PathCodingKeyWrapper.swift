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
