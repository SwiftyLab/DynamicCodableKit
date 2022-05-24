import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingWrapperTests: XCTestCase {
    func testDecoding() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(SinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content.type, .video)
        XCTAssertEqual(postPage.content.likes, 2345)
    }

    func testOptionalDecoding() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalSinglePostPage.self, from: data)
        XCTAssertEqual(postPage.content?.type, .video)
        XCTAssertEqual(postPage.content?.likes, 2345)
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(SinglePostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(OptionalSinglePostPage.self, from: data)
        XCTAssertNil(postPage.content)
    }
}

struct SinglePostPage: Decodable {
    let next: URL
    @DynamicDecodingWrapper<PostCodingKey> var content: Post
}

struct OptionalSinglePostPage: Decodable {
    let next: URL
    @OptionalDynamicDecodingWrapper<PostCodingKey> var content: Post?
}
