# Decoding with Type Identifiers

Decode dynamic JSON objects based on single or mutiple identifiers that indicates the actual type to decode.

## Overview

It is quite common in JSON responses to have objects that have some common fields while providing some additional fields based on object type. Below is a JSON response for a social media page that contains different types of posts:
```json
{
  "content": [
    {
      "id": "00005678-abcd-efab-0123-456789abcdef",
      "type": "text",
      "author": "12345678-abcd-efab-0123-456789abcdef",
      "likes": 145,
      "createdAt": "2021-07-23T07:36:43Z",
      "text": "Lorem Ipsium"
    },
    {
      "id": "43215678-abcd-efab-0123-456789abcdef",
      "type": "picture",
      "author": "abcd5678-abcd-efab-0123-456789abcdef",
      "likes": 370,
      "createdAt": "2021-07-23T09:32:13Z",
      "url": "https://a.url.com/to/a/picture.png",
      "caption": "Lorem Ipsium"
    },
    {
      "id": "64475bcb-caff-48c1-bb53-8376628b350b",
      "type": "audio",
      "author": "4c17c269-1c56-45ab-8863-d8924ece1d0b",
      "likes": 25,
      "createdAt": "2021-07-23T09:33:48Z",
      "url": "https://a.url.com/to/a/audio.aac",
      "duration": 60
    },
    {
      "id": "98765432-abcd-efab-0123-456789abcdef",
      "type": "video",
      "author": "04355678-abcd-efab-0123-456789abcdef",
      "likes": 2345,
      "createdAt": "2021-07-23T09:36:38Z",
      "url": "https://a.url.com/to/a/video.mp4",
      "duration": 460,
      "thumbnail": "https://a.url.com/to/a/thmbnail.png"
    }
  ],
  "next": "https://a.url.com/to/next/page"
}
```

### Create Types to be Decoded

To summarize above JSON, posts can be either **Text** based, includes **Picture**, **Audio** or **Video**. The `type` field indicates the object type and indicates additional fields available while fields like `id`, `author`, `likes`, `createdAt` are common for all types.
![Social media page posts JSON data hierarchy.](identifier-json)

Decoding dynamically can be handled by creating types representing every post type: `TextPost`, `PicturePost`, `AudioPost`, `VideoPost` each confirming to ``DynamicDecodable`` and to protocol `Post` which represents common post type.
![Decoded models hierarchy.](identifier-class)

### Implement Dynamic Decoding Contexts

Now `Post` type can be dynamically decoded to its concrete type based on value of `PostType` identiifier. `PostType` can be created as an `Enum` confirming to ``DynamicDecodingContextIdentifierKey`` while implementing the decoding context to use with ``DynamicDecodingContextIdentifierKey/associatedContext``. To allow `Decoder` to decode `PostType` and get dynamic decoding context, additional `CodingKey` type `PostCodingKey` need to be defined confirming to ``DynamicDecodingContextCodingKey``. Since current example only has one itentifier to decode confirming to ``DynamicDecodingContextIdentifierCodingKey`` and providing key that contains the identifier in ``DynamicDecodingContextIdentifierCodingKey/identifierCodingKey`` will suffice.
```swift
enum PostCodingKey: String, DynamicDecodingContextIdentifierCodingKey {
    typealias Identifier = PostType
    typealias Identified = Post
    case type
    static var identifierCodingKey: Self { .type }
}

enum PostType: String, DynamicDecodingContextIdentifierKey {
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
```

Finally, `PostPage` can be decoded with all the dynamic post contents by using ``DynamicDecodingCollectionWrapper`` property wrapper to wrap `content` array.
```swift
struct PostPage: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayWrapper<PostCodingKey> var content: [Post]
}
```
> Tip: You can use the lossy versions, i.e. ``LossyDynamicDecodingArrayWrapper`` to decode only valid post data while ignoring the rest. See more in <doc:CollectionDecoding>.

## Topics

### Protocols

- ``DynamicDecodingContextIdentifierKey``
- ``DynamicDecodingContextIdentifierCodingKey``
- ``DynamicDecodingContextCodingKey``

### Property Wrappers

- ``DynamicDecodingWrapper``
- ``DynamicDecodingDefaultValueWrapper``
- ``DynamicDecodingCollectionWrapper``

### Type Aliases

- ``OptionalDynamicDecodingWrapper``
- ``StrictDynamicDecodingArrayWrapper``
- ``DefaultValueDynamicDecodingArrayWrapper``
- ``LossyDynamicDecodingArrayWrapper``
- ``StrictDynamicDecodingCollectionWrapper``
- ``DefaultValueDynamicDecodingCollectionWrapper``
- ``LossyDynamicDecodingCollectionWrapper``