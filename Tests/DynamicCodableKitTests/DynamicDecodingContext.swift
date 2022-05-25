import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingContextTests: XCTestCase {
    func testFallbackDecodingWithPrimarySucess() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: VideoPost.self, fallback: TextPost.self)
        let postPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testFallbackDecodingWithFallbackSucess() throws {
        let data = identifierDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self, fallback: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testFallbackArrayDecoding() throws {
        let data = providerCollectionDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self, fallback: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedThrowingPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 3)
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = providerCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self, fallback: VideoPost.self)
        XCTAssertThrowsError(try decoder.decode(ProviderBasedThrowingPostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let data = providerCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self, fallback: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedDefaultPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 0)
    }

    func testInvalidDataDecodingWithLossyConfig() throws {
        let data = providerCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self, fallback: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedLossyPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 5)
    }
}
