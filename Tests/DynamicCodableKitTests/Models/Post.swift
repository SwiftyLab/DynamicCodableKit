import XCTest
@testable import DynamicCodableKit

enum PostType: String, Hashable, DynamicDecodingContextIdentifierKey {
    case text, picture, audio, video

    var associatedContext: DynamicDecodingContext<Post> {
        switch self {
        case .text:
            return DynamicDecodingContext(decoding: TextPost.self)
        case .picture:
            return DynamicDecodingContext(decoding: PicturePost.self)
        case .audio:
            return DynamicDecodingContext(decoding: AudioPost.self)
        case .video:
            return DynamicDecodingContext(decoding: VideoPost.self)
        }
    }
}

protocol Post: DynamicDecodable {
    var id: UUID { get }
    var type: PostType { get }
    var author: UUID { get }
    var likes: Int { get }
    var createdAt: String { get }
}

struct TextPost: Post, Hashable {
    let id: UUID
    let type: PostType
    let author: UUID
    let likes: Int
    let createdAt: String
    let text: String
}

struct PicturePost: Post, Hashable {
    let id: UUID
    let type: PostType
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let caption: String
}

struct AudioPost: Post, Hashable {
    let id: UUID
    let type: PostType
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let duration: Int
}

struct VideoPost: Post, Hashable {
    let id: UUID
    let type: PostType
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let duration: Int
    let thumbnail: URL
}

enum PostCodingKey: String, DynamicDecodingContextIdentifierCodingKey {
    typealias Identifier = PostType
    typealias Identified = Post
    case type
    static var identifierCodingKey: Self { .type }
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
