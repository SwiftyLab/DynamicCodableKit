import XCTest
@testable import DynamicCodableKit

struct SinglePostPage: Decodable {
    let next: URL
    @DynamicDecodingWrapper<PostCodingKey> var content: Post
}

struct OptionalSinglePostPage: Decodable {
    let next: URL
    @OptionalDynamicDecodingWrapper<PostCodingKey> var content: Post?
}

struct ThrowingPostPage: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct DefaultPostPage: Decodable {
    let next: URL
    @DefaultValueDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct LossyPostPage: Decodable {
    let next: URL
    @LossyDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct ThrowingPostPageSet: Decodable {
    let next: URL
    @StrictDynamicDecodingCollectionWrapper<PostSetCodingKey, Set<AnyPost<Post>>> var content: Set<AnyPost<Post>>
}

struct DefaultPostPageSet: Decodable {
    let next: URL
    @DefaultValueDynamicDecodingCollectionWrapper<PostSetCodingKey, Set<AnyPost<Post>>> var content: Set<AnyPost<Post>>
}

struct LossyPostPageSet: Decodable {
    let next: URL
    @LossyDynamicDecodingCollectionWrapper<PostSetCodingKey, Set<AnyPost<Post>>> var content: Set<AnyPost<Post>>
}
