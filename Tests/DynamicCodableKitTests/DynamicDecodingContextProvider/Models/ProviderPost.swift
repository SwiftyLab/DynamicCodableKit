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
    let next: URL
    @OptionalDynamicDecodingContextBasedWrapper<PostDecodingProvider> var content: Post?
}

struct ProviderBasedThrowingPostPage: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayContextBasedWrapper<PostDecodingProvider> var content: [Post]
}

struct ProviderBasedDefaultPostPage: Decodable {
    let next: URL
    @DefaultValueDynamicDecodingArrayContextBasedWrapper<PostDecodingProvider> var content: [Post]
}

struct ProviderBasedLossyPostPage: Decodable {
    let next: URL
    @LossyDynamicDecodingArrayContextBasedWrapper<PostDecodingProvider> var content: [Post]
}
