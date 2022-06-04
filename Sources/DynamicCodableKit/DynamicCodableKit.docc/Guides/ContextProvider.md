# Decoding with Provided Context

Decode dynamic JSON objects based on previous responses or actions by providing decoding context to top level decoder, i.e. `JSONDecoder`.

## Overview

In certain scenarios, the data type present in JSON response will be dependant on previous JSON responses or a specific action performed. For example, in a social media post detail response, the data present will be indicated by the post type the detail is for, i.e. text based post, picture, audio or video post:
```json
{
  "id": "00005678-abcd-efab-0123-456789abcdef",
  "author": "12345678-abcd-efab-0123-456789abcdef",
  "likes": 145,
  "createdAt": "2021-07-23T07:36:43Z",
  "title": "Lorem Ipsium",
  "description": "Lorem Ipsium",
  "text": "Lorem Ipsium"
}
```
```json
{
  "id": "43215678-abcd-efab-0123-456789abcdef",
  "author": "abcd5678-abcd-efab-0123-456789abcdef",
  "likes": 370,
  "createdAt": "2021-07-23T09:32:13Z",
  "url": "https://a.url.com/to/a/picture.png",
  "caption": "Lorem Ipsium",
  "size": {
    "hight": 1080,
    "width": 1920
  }
}
```
```json
{
  "id": "64475bcb-caff-48c1-bb53-8376628b350b",
  "author": "4c17c269-1c56-45ab-8863-d8924ece1d0b",
  "likes": 25,
  "createdAt": "2021-07-23T09:33:48Z",
  "url": "https://a.url.com/to/a/audio.aac",
  "duration": 60,
  "lyrics": "https://a.url.com/to/a/text.txt",
}
```
```json
{
  "id": "98765432-abcd-efab-0123-456789abcdef",
  "author": "04355678-abcd-efab-0123-456789abcdef",
  "likes": 2345,
  "createdAt": "2021-07-23T09:36:38Z",
  "url": "https://a.url.com/to/a/video.mp4",
  "duration": 460,
  "thumbnail": "https://a.url.com/to/a/thumbnail.png",
  "subTitles": "https://a.url.com/to/a/subTitles.srt",
  "aspectRatio": {
    "hight": 9,
    "width": 16
  }
}
```

To decode post detail JSON dynamically, type representing every post type: `TextPostDetail`, `PicturePostDetail`, `AudioPostDetail`, `VideoPostDetail` can be created, each confirming to ``DynamicDecodable`` and to protocol `PostDetail` which represents common post detail type.
![Decoded models hierarchy.](context-provider-class)

A ``DynamicDecodingContextProvider`` can be created to provide dynamic decoding context. For the current example, a type confirming ``UserInfoDynamicDecodingContextProvider`` can be created that provides the decoding context present in `Decoder`'s `userInfo` property associated to ``UserInfoDynamicDecodingContextProvider/infoKey``.
```swift
extension CodingUserInfoKey {
    static let postDetailDecodingContext = CodingUserInfoKey(rawValue: "post_detail_decoding_context")!
}

struct PostDetailDecodingContextProvider: UserInfoDynamicDecodingContextProvider {
    static var infoKey: CodingUserInfoKey { .postDetailDecodingContext }
}
```

Finally, the top `Decodable` model can be created with ``DynamicDecodingContextBasedWrapper`` wrapped property to consume the decoding context provided:
```swift
struct PostDetailPage: Decodable {
    let next: URL
    @DynamicDecodingContextBasedWrapper<PostDetailDecodingContextProvider> var data: PostDetail
}
```

Before decoding, the context can be provided in the top level decoder's `userInfo` property to be consumed later. If a text post is clicked, then assuming the `TextPostDetail` type would be decoded:
```swift
let decoder = JSONDecoder()
decoder.userInfo[.postDetailDecodingContext] = DynamicDecodingContext(decoding: TextPostDetail.self)
let detailPage = try decoder.decode(PostDetailPage.self, from: json)
```

## Topics

### Protocols

- ``UserInfoDynamicDecodingContextProvider``
- ``DynamicDecodingContextProvider``

### Property Wrappers

- ``DynamicDecodingContextBasedWrapper``
- ``DynamicDecodingDefaultValueContextBasedWrapper``
- ``DynamicDecodingCollectionContextBasedWrapper``

### Type Aliases

- ``OptionalDynamicDecodingContextBasedWrapper``
- ``StrictDynamicDecodingArrayContextBasedWrapper``
- ``DefaultValueDynamicDecodingArrayContextBasedWrapper``
- ``LossyDynamicDecodingArrayContextBasedWrapper``
- ``StrictDynamicDecodingCollectionContextBasedWrapper``
- ``DefaultValueDynamicDecodingCollectionContextBasedWrapper``
- ``LossyDynamicDecodingCollectionContextBasedWrapper``