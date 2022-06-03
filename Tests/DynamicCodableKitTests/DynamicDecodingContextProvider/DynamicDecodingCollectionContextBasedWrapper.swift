import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingCollectionContextBasedWrapperTests: XCTestCase {
    func testDecoding() throws {
        let data = identifierCollectionDecode
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(
            withKey: PostCodingKey.self
        )
        let postPage = try decoder.decode(
            ProviderBasedThrowingPostPage.self,
            from: data
        )
        XCTAssertEqual(postPage.content.count, 4)
        XCTAssertEqual(
            postPage.content.map(\.type),
            [.text, .picture, .audio, .video]
        )
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = identifierCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode(ProviderBasedThrowingPostPage.self, from: data)
        )
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let data = identifierCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(
            withKey: PostCodingKey.self
        )
        let postPage = try decoder.decode(
            ProviderBasedDefaultPostPage.self,
            from: data
        )
        XCTAssertEqual(postPage.content.count, 0)
    }

    func testInvalidDataDecodingWithLossyConfig() throws {
        let data = identifierCollectionDecodeWithInvalidData
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(
            withKey: PostCodingKey.self
        )
        let postPage = try decoder.decode(
            ProviderBasedLossyPostPage.self,
            from: data
        )
        XCTAssertEqual(postPage.content.count, 4)
        XCTAssertEqual(
            postPage.content.map(\.type),
            [.text, .picture, .audio, .video]
        )
    }
}
