import XCTest
@testable import DynamicCodableKit

struct SinglePostPage: Codable {
    let next: URL
    @DynamicDecodingWrapper<PostCodingKey> var content: Post
}

struct OptionalSinglePostPage: Codable {
    let next: URL
    @OptionalDynamicDecodingWrapper<PostCodingKey> var content: Post?
}

struct ThrowingPostPage: Codable {
    let next: URL
    @StrictDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct DefaultPostPage: Codable {
    let next: URL
    @DefaultValueDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct LossyPostPage: Codable {
    let next: URL
    @LossyDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}

struct ThrowingPostPageSet: Codable {
    let next: URL
    @StrictDynamicDecodingCollectionWrapper<
        PostSetCodingKey, Set<AnyPost<Post>>
    > var content: Set<AnyPost<Post>>
}

struct DefaultPostPageSet: Codable {
    let next: URL
    @DefaultValueDynamicDecodingCollectionWrapper<
        PostSetCodingKey, Set<AnyPost<Post>>
    > var content: Set<AnyPost<Post>>
}

struct LossyPostPageSet: Codable {
    let next: URL
    @LossyDynamicDecodingCollectionWrapper<PostSetCodingKey, Set<AnyPost<Post>>>
    var content: Set<AnyPost<Post>>
}
