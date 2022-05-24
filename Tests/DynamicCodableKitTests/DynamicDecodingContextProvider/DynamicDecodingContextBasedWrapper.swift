import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingContextBasedWrapperTests: XCTestCase {
    func testDecoding() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testOptionalDecoding() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: VideoPost.self)
        let postPage = try decoder.decode(ProviderBasedOptionalSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content?.type, .video)
        XCTAssertEqual(postPage.content?.likes, 2345)
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ProviderBasedSinglePostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(ProviderBasedOptionalSinglePostPage.self, from: data)
        XCTAssertNil(postPage.content)
    }
}
