import XCTest
@testable import DynamicCodableKit

struct ThrowingKeyedPostPage: Codable {
    let next: URL
    @StrictDynamicDecodingDictionaryWrapper<PostType> var content: [PostType: Post]
}

struct LossyKeyedPostPage: Codable {
    let next: URL
    @LossyDynamicDecodingDictionaryWrapper<PostType> var content: [PostType: Post]
}

struct ThrowingKeyedPostPageCollection: Codable {
    let next: URL
    @StrictDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}

struct DefaultValueKeyedPostPageCollection: Codable {
    let next: URL
    @DefaultValueDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}

struct LossyKeyedPostPageCollection: Codable {
    let next: URL
    @LossyDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}
