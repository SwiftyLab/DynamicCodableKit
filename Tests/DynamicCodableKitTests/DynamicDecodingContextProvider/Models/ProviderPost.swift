import XCTest
@testable import DynamicCodableKit

extension CodingUserInfoKey {
    static let postKey = CodingUserInfoKey(rawValue: "post_key")!
}

struct PostDecodingProvider: UserInfoDynamicDecodingContextProvider {
    typealias Identified = Post
    static var infoKey: CodingUserInfoKey { .postKey }
}

struct ProviderBasedSinglePostPage: Decodable {
    let next: URL
    @DynamicDecodingContextBasedWrapper<PostDecodingProvider> var content: Post
}

struct ProviderBasedOptionalSinglePostPage: Decodable {
    typealias PostWrapper = OptionalDynamicDecodingContextBasedWrapper<
        PostDecodingProvider
    >
    let next: URL
    @PostWrapper var content: Post?
}

struct ProviderBasedThrowingPostPage: Decodable {
    typealias PostWrapper = StrictDynamicDecodingArrayContextBasedWrapper<
        PostDecodingProvider
    >
    let next: URL
    @PostWrapper var content: [Post]
}

struct ProviderBasedDefaultPostPage: Decodable {
    typealias PostWrapper = DefaultValueDynamicDecodingArrayContextBasedWrapper<
        PostDecodingProvider
    >
    let next: URL
    @PostWrapper var content: [Post]
}

struct ProviderBasedLossyPostPage: Decodable {
    typealias PostWrapper = LossyDynamicDecodingArrayContextBasedWrapper<
        PostDecodingProvider
    >
    let next: URL
    @PostWrapper var content: [Post]
}
