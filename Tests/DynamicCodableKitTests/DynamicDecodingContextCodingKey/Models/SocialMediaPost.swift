import XCTest
@testable import DynamicCodableKit

struct SocialMediaPost: Codable {
    typealias CodingKeys = SocialMediaPostCodingKey
    typealias MetaData = DynamicDecodingWrapper<CodingKeys>
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @MetaData var metadata: PostMetaData

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.author = try container.decode(UUID.self, forKey: .author)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self._metadata = try container.decode(MetaData.self, forKey: .metadata)
    }
}

struct OptionalMetadataPost: Codable {
    typealias CodingKeys = SocialMediaPostCodingKey
    typealias MetaData = OptionalDynamicDecodingWrapper<CodingKeys>
    let id: UUID
    let author: UUID
    let likes: Int
    let createdAt: String
    @MetaData var metadata: PostMetaData?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.author = try container.decode(UUID.self, forKey: .author)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self._metadata = container.decode(MetaData.self, forKey: .metadata)
    }
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
