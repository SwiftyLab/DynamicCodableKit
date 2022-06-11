import XCTest
@testable import DynamicCodableKit

struct SocialMediaPost: Codable {
    typealias CodingKeys = SocialMediaPostCodingKey
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @DynamicDecodingWrapper<CodingKeys> var metadata: PostMetaData
}

struct OptionalMetadataPost: Codable {
    typealias CodingKeys = SocialMediaPostCodingKey
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @OptionalDynamicDecodingWrapper<CodingKeys> var metadata: PostMetaData?
}

enum PostMetaDataType: String,
    Hashable,
    DynamicDecodingContextIdentifierKey
{
    case text, picture, audio, video

    var associatedContext: DynamicDecodingContext<PostMetaData> {
        switch self {
        case .text:
            return DynamicDecodingContext(decoding: TextPostMetaData.self)
        case .picture:
            return DynamicDecodingContext(decoding: PicturePostMetaData.self)
        case .audio:
            return DynamicDecodingContext(decoding: AudioPostMetaData.self)
        case .video:
            return DynamicDecodingContext(decoding: VideoPostMetaData.self)
        }
    }
}

enum SocialMediaPostCodingKey: String,
    DynamicDecodingContextIdentifierCodingKey
{
    typealias Identifier = PostMetaDataType
    typealias Identified = PostMetaData
    case id
    case author
    case likes
    case createdAt
    case metadata
    static var identifierCodingKey: Self { .metadata }
}

protocol PostMetaData: DynamicDecodable {}

struct TextPostMetaData: PostMetaData {
    let text: String
}

struct PicturePostMetaData: PostMetaData {
    let url: URL
    let caption: String
}

struct AudioPostMetaData: PostMetaData {
    let url: URL
    let duration: Int
}

struct VideoPostMetaData: PostMetaData {
    let url: URL
    let duration: Int
    let thumbnail: URL
}
