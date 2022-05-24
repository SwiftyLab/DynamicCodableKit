import XCTest
@testable import DynamicCodableKit

struct ThrowingKeyedPostPage: Decodable {
    let next: URL
    @StrictDynamicDecodingDictionaryWrapper<PostType> var content: [PostType: Post]
}

struct LossyKeyedPostPage: Decodable {
    let next: URL
    @LossyDynamicDecodingDictionaryWrapper<PostType> var content: [PostType: Post]
}

struct ThrowingKeyedPostPageCollection: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}

struct DefaultValueKeyedPostPageCollection: Decodable {
    let next: URL
    @DefaultValueDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}

struct LossyKeyedPostPageCollection: Decodable {
    let next: URL
    @LossyDynamicDecodingArrayDictionaryWrapper<PostType> var content: [PostType: [Post]]
}
