import XCTest
@testable import DynamicCodableKit

struct ThrowingKeyedPostPage: Codable {
    typealias PostWrapper = StrictDynamicDecodingDictionaryWrapper<PostType>
    let next: URL
    @PostWrapper var content: [PostType: Post]
}

struct LossyKeyedPostPage: Codable {
    typealias PostWrapper = LossyDynamicDecodingDictionaryWrapper<PostType>
    let next: URL
    @PostWrapper var content: [PostType: Post]
}

struct ThrowingKeyedPostPageCollection: Codable {
    typealias PostWrapper = StrictDynamicDecodingArrayDictionaryWrapper<
        PostType
    >
    let next: URL
    @PostWrapper var content: [PostType: [Post]]
}

struct DefaultValueKeyedPostPageCollection: Codable {
    typealias PostWrapper = DefaultValueDynamicDecodingArrayDictionaryWrapper<
        PostType
    >
    let next: URL
    @PostWrapper var content: [PostType: [Post]]
}

struct LossyKeyedPostPageCollection: Codable {
    typealias PostWrapper = LossyDynamicDecodingArrayDictionaryWrapper<PostType>
    let next: URL
    @PostWrapper var content: [PostType: [Post]]
}
