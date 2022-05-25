import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingWrapperTests: XCTestCase {
    func testDecoding() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(SinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testOptionalDecoding() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content?.type, .video)
        XCTAssertEqual(postPage.content?.likes, 2345)
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = identifierDecodeWithInvalidData
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(SinglePostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let data = identifierDecodeWithInvalidData
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalSinglePostPage.self, from: data)
        XCTAssertNil(postPage.content)
    }
}
