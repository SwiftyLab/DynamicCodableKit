import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingDictionaryWrapperTests: XCTestCase {
    func testDecoding() throws {
        let data = containerDecode
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(
            ThrowingKeyedPostPage.self,
            from: data
        )
        XCTAssertEqual(postPage.content.count, 4)
        XCTAssertEqual(
            Set(postPage.content.map(\.value.type)),
            Set([.text, .picture, .audio, .video])
        )
        postPage.content.forEach { XCTAssertEqual($1.type, $0) }
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let data = containerDecodeWithInvalidData
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode(ThrowingKeyedPostPage.self, from: data)
        )
    }

    func testInvalidDataDecodingWithLossyConfig() throws {
        let data = containerDecodeWithInvalidData
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(LossyKeyedPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 3)
        XCTAssertEqual(
            Set(postPage.content.map(\.value.type)),
            Set([.text, .picture, .video])
        )
        postPage.content.forEach { XCTAssertEqual($1.type, $0) }
    }
}
