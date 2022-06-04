# Decoding with Parent CodingKey

Decode dynamic JSON objects based on parent coding key that indicates the actual type to decode.

## Overview

Alternative to <doc:TypeIdentifier>, in some JSON responses different types of objects are already grouped with a specific parent coding key. Below is a JSON response for a social media page that contains different types of posts that are already grouped by post type:
```json
{
  "content": {
    "text": [
      {
        "id": "00005678-abcd-efab-0123-456789abcdef",
        "type": "text",
        "author": "12345678-abcd-efab-0123-456789abcdef",
        "likes": 145,
        "createdAt": "2021-07-23T07:36:43Z",
        "text": "Lorem Ipsium"
      }
    ],
    "picture": [
      {
        "id": "43215678-abcd-efab-0123-456789abcdef",
        "type": "picture",
        "author": "abcd5678-abcd-efab-0123-456789abcdef",
        "likes": 370,
        "createdAt": "2021-07-23T09:32:13Z",
        "url": "https://a.url.com/to/a/picture.png",
        "caption": "Lorem Ipsium"
      }
    ],
    "audio": [
      {
        "id": "64475bcb-caff-48c1-bb53-8376628b350b",
        "type": "audio",
        "author": "4c17c269-1c56-45ab-8863-d8924ece1d0b",
        "likes": 25,
        "createdAt": "2021-07-23T09:33:48Z",
        "url": "https://a.url.com/to/a/audio.aac",
        "duration": 60
      }
    ],
    "video": [
      {
        "id": "98765432-abcd-efab-0123-456789abcdef",
        "type": "video",
        "author": "04355678-abcd-efab-0123-456789abcdef",
        "likes": 2345,
        "createdAt": "2021-07-23T09:36:38Z",
        "url": "https://a.url.com/to/a/video.mp4",
        "duration": 460,
        "thumbnail": "https://a.url.com/to/a/thumbnail.png"
      }
    ]
  },
  "next": "https://a.url.com/to/next/page"
}
```

### Create Types to be Decoded

To summarize above JSON, posts can be either **Text** based, includes **Picture**, **Audio** or **Video**. The `type` field indicates the object type and indicates additional fields available while fields like `id`, `author`, `likes`, `createdAt` are common for all types.
![Social media page posts JSON data hierarchy.](container-json)

Decoding dynamically can be handled by creating types representing every post type: `TextPost`, `PicturePost`, `AudioPost`, `VideoPost` each confirming to ``DynamicDecodable`` and to protocol `Post` which represents common post type.
![Decoded models hierarchy.](identifier-class)

### Implement Dynamic Decoding Contexts

Now `Post` type can be dynamically decoded to its concrete type based on value of `PostCodingKey` key. `PostCodingKey` can be created as an `Enum` confirming to ``DynamicDecodingContextContainerCodingKey`` while implementing the decoding context to use with ``DynamicDecodingContextContainerCodingKey/containedContext-15p5u``.
```swift
enum PostCodingKey: String, Hashable, DynamicDecodingContextContainerCodingKey {
    case text, picture, audio, video

    var containedContext: DynamicDecodingContext<Post> {
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

Finally, `PostPage` can be decoded with all the dynamic post contents by using ``DynamicDecodingCollectionDictionaryWrapper`` property wrapper to wrap `content` dictionary.
```swift
struct PostPage: Decodable {
    let next: URL
    @StrictDynamicDecodingArrayDictionaryWrapper<PostCodingKey> var content: [PostCodingKey: Post]
}
```
> Tip: You can use the lossy versions, i.e. ``LossyDynamicDecodingArrayDictionaryWrapper`` to decode only valid post data while ignoring the rest. See more in <doc:CollectionDecoding>.

## Topics

### Protocols

- ``DynamicDecodingContextContainerCodingKey``

### Property Wrappers

- ``DynamicDecodingDictionaryWrapper``
- ``DynamicDecodingCollectionDictionaryWrapper``
- ``PathCodingKeyWrapper``
- ``PathCodingKeyDefaultValueWrapper``

### Type Aliases

- ``StrictDynamicDecodingDictionaryWrapper``
- ``LossyDynamicDecodingDictionaryWrapper``
- ``StrictDynamicDecodingArrayDictionaryWrapper``
- ``DefaultValueDynamicDecodingArrayDictionaryWrapper``
- ``LossyDynamicDecodingArrayDictionaryWrapper``
- ``StrictDynamicDecodingCollectionDictionaryWrapper``
- ``DefaultValueDynamicDecodingCollectionDictionaryWrapper``
- ``LossyDynamicDecodingCollectionDictionaryWrapper``
- ``OptionalPathCodingKeyWrapper``
