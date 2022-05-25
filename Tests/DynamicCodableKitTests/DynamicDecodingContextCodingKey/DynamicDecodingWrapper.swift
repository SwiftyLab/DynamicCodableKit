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

    func testDynamicTypeDecodingWithSelfCodingKeyContext() throws {
        let data = #"{"value": 86}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        let container = try decoder.decode(VariableBaseDataTypeContainer.self, from: data)
        XCTAssertEqual(container.value as? Int, 86)
    }

    func testOptionalDynamicTypeDecodingWithSelfCodingKeyContext() throws {
        let data = #"{"value": 86}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        let container = try decoder.decode(OptionalVariableBaseDataTypeContainer.self, from: data)
        XCTAssertEqual(container.value as? Int, 86)
    }

    func testInvalidDataDynamicTypeDecodingWithSelfCodingKeyContextWithThrowConfig() throws {
        let data = #"{"value": 86.89}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(VariableBaseDataTypeContainer.self, from: data))
    }

    func testInvalidDataDynamicTypeDecodingWithSelfCodingKeyContextWithDefaultConfig() throws {
        let data = #"{"value": 86.89}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        let container = try decoder.decode(OptionalVariableBaseDataTypeContainer.self, from: data)
        XCTAssertNil(container.value)
    }
}
