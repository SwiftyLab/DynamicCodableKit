import XCTest
@testable import DynamicCodableKit

enum PostSetType: String, DynamicDecodingContextIdentifierKey {
    case text, picture, audio, video

    var associatedContext: DynamicDecodingContext<AnyPost<Post>> {
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

extension DynamicDecodable where Self: Post {
    func castAs<T>(type: T.Type, codingPath: [CodingKey]) throws -> T {
        switch self {
        case let value as T:
            return value
        case _ where T.self is AnyPost<Post>.Type:
            return AnyPost(withValue: self as Post) as! T
        default:
            throw DecodingError.typeMismatch(T.self, codingPath: codingPath)
        }
    }
    func castAs<T: ExpressibleByNilLiteral>(type: T.Type, codingPath: [CodingKey]) -> T {
        return self as? T ?? AnyPost(withValue: self as Post) as? T ?? nil
    }
//    func castAs(type: AnyPost<Post>.Type, codingPath: [CodingKey]) throws -> AnyPost<Post> {
//        return AnyPost(withValue: self as Post)
//    }
}

@dynamicMemberLookup
struct AnyPost<P>: Hashable {
    let value: P

    init(withValue value: P) {
        self.value = value
    }

    static func == (lhs: AnyPost<P>, rhs: AnyPost<P>) -> Bool {
        lhs.value as! AnyHashable == rhs.value as! AnyHashable
    }

    func hash(into hasher: inout Hasher) {
        (value as! AnyHashable).hash(into: &hasher)
    }

    subscript<T>(dynamicMember path: KeyPath<P,T>) -> T {
        return value[keyPath: path]
    }
}

enum PostSetCodingKey: String, DynamicDecodingContextIdentifierCodingKey {
    typealias Identifier = PostSetType
    typealias Identified = AnyPost<Post>
    case type
    static var identifierCodingKey: Self { .type }
}
