import XCTest
@testable import DynamicCodableKit

final class DynamicEncodableTests: XCTestCase {
    func testEncoding() throws {
        let post = PicturePost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/picture.png")!,
            caption: "Lorem Ipsium"
        )
        let data = try JSONEncoder().encode(DynamicDecodingWrapper<PostCodingKey>(wrappedValue: post))
        let decodedPost = try JSONDecoder().decode(PicturePost.self, from: data)
        XCTAssertEqual(post, decodedPost)
    }

    func testDynamicEncoding() throws {
        let page = SinglePostPage(
            next: URL(string: "https://a.url.com/to/next/page")!,
            content: TextPost(
                id: UUID(),
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                text: "Lorem Ipsium"
            )
        )
        let data = try JSONEncoder().encode(page)
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self)
        let decodedPage = try decoder.decode(ProviderBasedSinglePostPage.self, from: data)
        XCTAssertEqual(page.next, decodedPage.next)
        XCTAssertEqual(page.content as! TextPost, decodedPage.content as! TextPost)
    }

    func testEncodingFailure() throws {
        let posts = AudioPost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/audio.aac")!,
            duration: 240
        )
        XCTAssertThrowsError(try JSONEncoder().encode(DynamicDecodingWrapper<PostCodingKey>(wrappedValue: posts)))
    }

    func testOptionalEncoding() throws {
        let post = PicturePost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/picture.png")!,
            caption: "Lorem Ipsium"
        )
        let data = try JSONEncoder().encode(OptionalDynamicDecodingWrapper<PostCodingKey>(wrappedValue: post))
        let decodedPost = try JSONDecoder().decode(PicturePost.self, from: data)
        XCTAssertEqual(post, decodedPost)
    }

    func testOptionalDynamicEncoding() throws {
        let page = OptionalSinglePostPage(
            next: URL(string: "https://a.url.com/to/next/page")!,
            content: TextPost(
                id: UUID(),
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                text: "Lorem Ipsium"
            )
        )
        let data = try JSONEncoder().encode(page)
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self)
        let decodedPage = try decoder.decode(ProviderBasedOptionalSinglePostPage.self, from: data)
        XCTAssertEqual(page.next, decodedPage.next)
        XCTAssertNotNil(decodedPage.content)
        XCTAssertEqual(page.content as! TextPost, decodedPage.content as! TextPost)
    }

    func testOptionalEncodingFailure() throws {
        let posts = AudioPost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/audio.aac")!,
            duration: 240
        )
        XCTAssertThrowsError(try JSONEncoder().encode(OptionalDynamicDecodingWrapper<PostCodingKey>(wrappedValue: posts)))
    }

    func testArrayEncoding() throws {
        let posts = Array(
            repeating: PicturePost(
                id: UUID(),
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                url: URL(string: "https://a.url.com/to/a/picture.png")!,
                caption: "Lorem Ipsium"
            ),
            count: 3
        )
        let data = try JSONEncoder().encode(StrictDynamicDecodingArrayWrapper<PostCodingKey>(wrappedValue: posts))
        let decodedPosts = try JSONDecoder().decode([PicturePost].self, from: data)
        XCTAssertEqual(posts, decodedPosts)
    }

    func testDynamicArrayEncoding() throws {
        let page = ThrowingPostPage(
            next: URL(string: "https://a.url.com/to/next/page")!,
            content: Array(
                repeating: TextPost(
                    id: UUID(),
                    author: UUID(),
                    likes: 78,
                    createdAt: "2021-07-23T07:36:43Z",
                    text: "Lorem Ipsium"
                ),
                count: 3
            )
        )
        let data = try JSONEncoder().encode(page)
        let decoder = JSONDecoder()
        decoder.userInfo[.postKey] = DynamicDecodingContext<Post>(decoding: TextPost.self)
        let decodedPage = try decoder.decode(ProviderBasedDefaultPostPage.self, from: data)
        XCTAssertEqual(page.next, decodedPage.next)
        XCTAssertEqual(page.content as? [TextPost], decodedPage.content as? [TextPost])
    }

    func testArrayEncodingFailure() throws {
        let posts = Array(
            repeating: AudioPost(
                id: UUID(),
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                url: URL(string: "https://a.url.com/to/a/audio.aac")!,
                duration: 240
            ),
            count: 3
        )
        let data = try JSONEncoder().encode(StrictDynamicDecodingArrayWrapper<PostCodingKey>(wrappedValue: posts))
        let decodedPosts = try JSONDecoder().decode([AudioPost].self, from: data)
        XCTAssertEqual(0, decodedPosts.count)
        XCTAssertNotEqual(posts.count, decodedPosts.count)
    }

    func testEmptyEncoding() throws {
        let key = PathCodingKeyWrapper(wrappedValue: PostType.picture)
        XCTAssertThrowsError(try JSONEncoder().encode(key))
    }

    func testOptionalEmptyEncoding() throws {
        let key = OptionalPathCodingKeyWrapper(wrappedValue: PostType.picture)
        XCTAssertThrowsError(try JSONEncoder().encode(key))
    }

    func testDynamicDictionaryEncoding() throws {
        typealias Wrapper = StrictDynamicDecodingDictionaryWrapper<PostType>
        let postPage = try JSONDecoder().decode(ThrowingKeyedPostPage.self, from: containerDecode)
        let data = try JSONEncoder().encode(Wrapper(wrappedValue: postPage.content))
        let decodedWrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        XCTAssertNotEqual(postPage.content.count, decodedWrapper.wrappedValue.count)
        XCTAssertEqual(decodedWrapper.wrappedValue.count, 2)
        XCTAssertEqual(Set(decodedWrapper.wrappedValue.keys), [.text, .picture])
    }

    func testDynamicCollectionDictionaryEncoding() throws {
        typealias Wrapper = StrictDynamicDecodingArrayDictionaryWrapper<PostType>
        let postPage = try JSONDecoder().decode(ThrowingKeyedPostPageCollection.self, from: containerCollectionDecode)
        let data = try JSONEncoder().encode(Wrapper(wrappedValue: postPage.content))
        let decodedWrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        XCTAssertEqual(decodedWrapper.wrappedValue.count, 4)
        XCTAssertEqual(Set(decodedWrapper.wrappedValue.filter(\.value.isEmpty).keys), [.audio, .video])
    }

    func testProviderEncoding() throws {
        let post = PicturePost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/picture.png")!,
            caption: "Lorem Ipsium"
        )
        let data = try JSONEncoder().encode(DynamicDecodingContextBasedWrapper<PostDecodingProvider>(wrappedValue: post))
        let decodedPost = try JSONDecoder().decode(PicturePost.self, from: data)
        XCTAssertEqual(post, decodedPost)
    }

    func testOptionalProviderEncoding() throws {
        let post = PicturePost(
            id: UUID(),
            author: UUID(),
            likes: 78,
            createdAt: "2021-07-23T07:36:43Z",
            url: URL(string: "https://a.url.com/to/a/picture.png")!,
            caption: "Lorem Ipsium"
        )
        let data = try JSONEncoder().encode(OptionalDynamicDecodingContextBasedWrapper<PostDecodingProvider>(wrappedValue: post))
        let decodedPost = try JSONDecoder().decode(PicturePost.self, from: data)
        XCTAssertEqual(post, decodedPost)
    }

    func testProviderArrayEncoding() throws {
        let posts = Array(
            repeating: PicturePost(
                id: UUID(),
                author: UUID(),
                likes: 78,
                createdAt: "2021-07-23T07:36:43Z",
                url: URL(string: "https://a.url.com/to/a/picture.png")!,
                caption: "Lorem Ipsium"
            ),
            count: 3
        )
        let data = try JSONEncoder().encode(StrictDynamicDecodingArrayContextBasedWrapper<PostDecodingProvider>(wrappedValue: posts))
        let decodedPosts = try JSONDecoder().decode([PicturePost].self, from: data)
        XCTAssertEqual(posts, decodedPosts)
    }
}
