import XCTest
@testable import DynamicCodableKit

enum PostType: String,
               Hashable,
               DynamicDecodingContextIdentifierKey,
               DynamicDecodingContextContainerCodingKey {
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
    let author: UUID
    let likes: Int
    let createdAt: String
    let text: String
    var type: PostType { .text }
}

struct PicturePost: Post, Hashable {
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let caption: String
    var type: PostType { .picture }
}

struct AudioPost: Post, Hashable {
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let duration: Int
    var type: PostType { .audio }
}

struct VideoPost: Post, Hashable {
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    let url: URL
    let duration: Int
    let thumbnail: URL
    var type: PostType { .video }
}

enum PostCodingKey: String, DynamicDecodingContextIdentifierCodingKey {
    typealias Identifier = PostType
    typealias Identified = Post
    case type
    static var identifierCodingKey: Self { .type }
}
