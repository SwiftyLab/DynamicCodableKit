import XCTest
@testable import DynamicCodableKit

final class DynamicDecodingCollectionWrapperTests: XCTestCase {
    func testDecoding() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(ThrowingPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        XCTAssertEqual(postPage.content.map(\.type), [.text, .picture, .audio, .video])
    }

    func testInvalidDataDecodingWithThrowConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ThrowingPostPage.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(DefaultPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 0)
    }

    func testInvalidDataDecodingWithLossyConfig() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(LossyPostPage.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        XCTAssertEqual(postPage.content.map(\.type), [.text, .picture, .audio, .video])
    }

    // func testLossyDecodingPerformance() throws {
    //     let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
    //     let data = try Data(contentsOf: url)
    //     measure {
    //         let decoder = JSONDecoder()
    //         for _ in 0..<100 {
    //             _ = try? decoder.decode(LossyPostPage.self, from: data)
    //         }
    //     }
    // }

    func testDecodingWithSet() throws {
        let url = Bundle.module.url(forResource: "identifier-decode", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(ThrowingPostPageSet.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        let decodedPostTypes = Set(postPage.content.map(\.type))
        let expectedPostTypes: Set<PostType> = [.text, .picture, .audio, .video]
        XCTAssertEqual(decodedPostTypes, expectedPostTypes)
    }

    func testInvalidDataDecodingWithThrowConfigWithSet() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ThrowingPostPageSet.self, from: data))
    }

    func testInvalidDataDecodingWithDefaultConfigWithSet() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(DefaultPostPageSet.self, from: data)
        XCTAssertEqual(postPage.content.count, 0)
    }

    func testInvalidDataDecodingWithLossyConfigWithSet() throws {
        let url = Bundle.module.url(forResource: "identifier-decode-with-invalid-data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let postPage = try decoder.decode(LossyPostPageSet.self, from: data)
        XCTAssertEqual(postPage.content.count, 4)
        let decodedPostTypes = Set(postPage.content.map(\.type))
        let expectedPostTypes: Set<PostType> = [.text, .picture, .audio, .video]
        XCTAssertEqual(decodedPostTypes, expectedPostTypes)
    }
}