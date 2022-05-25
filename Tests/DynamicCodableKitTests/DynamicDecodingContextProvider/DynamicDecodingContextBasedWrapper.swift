import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingContextBasedWrapperTests: XCTestCase {
    func testDecoding() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testOptionalDecoding() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedOptionalSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content?.type, .video)
        XCTAssertEqual(postPage.content?.likes, 2345)
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = identifierDecodeWithInvalidData
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ProviderBasedSinglePostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let data = identifierDecodeWithInvalidData
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(ProviderBasedOptionalSinglePostPage.self, from: data)
        XCTAssertNil(postPage.content)
    }

    func testIdentifierKeyContextDecoding() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(withKey: PostCodingKey.self)
        let postPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }
}
