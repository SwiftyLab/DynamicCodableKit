import XCTest
@testable import DynamicCodableKit

final class DynamicDecodableTests: XCTestCase {
    func testCastingToExistential() throws {
        let textPost = TextPost(
            id: UUID(),
            type: .text,
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            text: "Lorem Ipsium"
        )
        let post = try textPost.castAs(type: Post.self, codingPath: [])
        XCTAssertEqual(post.type, .text)
    }
    func testCastingToBoxType() throws {
        let textPost = TextPost(
            id: UUID(),
            type: .text,
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            text: "Lorem Ipsium"
        )
        let post = try textPost.castAs(type: AnyPost<Post>.self, codingPath: [])
        XCTAssertEqual(post.type, .text)
    }
    func testOptionalCastingToExistential() throws {
        let textPost = TextPost(
            id: UUID(),
            type: .text,
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            text: "Lorem Ipsium"
        )
        let post = textPost.castAs(type: Post?.self, codingPath: [])
        XCTAssertEqual(post?.type, .text)
    }
    func testOptionalCastingToBoxType() throws {
        let textPost = TextPost(
            id: UUID(),
            type: .text,
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            text: "Lorem Ipsium"
        )
        let post = textPost.castAs(type: AnyPost<Post>?.self, codingPath: [])
        XCTAssertEqual(post?.type, .text)
    }
    func testArrayCastingToExistentialArray() throws {
        let textPosts = Array(
            repeating: TextPost(
                id: UUID(),
                type: .text,
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                text: "Lorem Ipsium"
            ),
            count: 10
        )
        let posts = try textPosts.castAs(type: [Post].self, codingPath: [])
        posts.forEach { XCTAssertEqual($0.type, .text) }
    }
    func testArrayCastingToBoxTypeArray() throws {
        let textPosts = Array(
            repeating: TextPost(
                id: UUID(),
                type: .text,
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                text: "Lorem Ipsium"
            ),
            count: 10
        )
        let posts = try textPosts.castAs(type: [AnyPost<Post>].self, codingPath: [])
        posts.forEach { XCTAssertEqual($0.type, .text) }
    }
    func testSetCastingToBoxTypeSet() throws {
        let textPosts: Set<TextPost> = [
            TextPost(
                id: UUID(),
                type: .text,
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                text: "Lorem Ipsium"
            ),
            TextPost(
                id: UUID(),
                type: .text,
                author: UUID(),
                likes: 88,
                createdAt: "2021-06-23T07:36:43Z",
                text: "Lorem Ipsium"
            ),
            TextPost(
                id: UUID(),
                type: .text,
                author: UUID(),
                likes: 887,
                createdAt: "2021-06-28T07:36:43Z",
                text: "Lorem Ipsium"
            )
        ]
        let posts = try textPosts.castAs(type: [AnyPost<Post>].self, codingPath: [])
        posts.forEach { XCTAssertEqual($0.type, .text) }
        let postSet = try textPosts.castAs(type: Set<AnyPost<Post>>.self, codingPath: [])
        postSet.forEach { XCTAssertEqual($0.type, .text) }
    }
}
