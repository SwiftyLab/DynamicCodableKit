# Configure Collection Type Decoding

Customize collection decoding failure handling with ``CollectionDecodeFailConfiguration`` value.

## Overview

`DynamicCodableKit` provides property wrappers for decoding collections.
These wrappers accept ``DynamicDecodingCollectionConfigurationProvider`` that provides configuration of type ``CollectionDecodeFailConfiguration`` with ``DynamicDecodingCollectionConfigurationProvider/failConfig``.


Implementation for all the configuration scenarios are provided with type aliases, depending upon following naming convention.

- Alases starting with `Strict..` indicate the if decoding fails then error is thrown.
- Alases starting with `DefaultValue..` indicate that in the event of decoding fail, empty collection is used.
- Alases starting with `Lossy..` provide safest decoding configuration. Each item in collection is decoded one by one, if the data for item is intact and valid item is added to collection, otherwise item is ignored.

In the <doc:TypeIdentifier> topic, ``StrictDynamicDecodingArrayWrapper`` will throw error decoding following response, while, ``DefaultValueDynamicDecodingArrayWrapper`` will decode an empty array and ``LossyDynamicDecodingArrayWrapper`` will ignore first two items and only decode the last item.
```json
{
  "content": [
    {
      "id": "4c76f901-3c4f-482c-8663-600a73416773",
      "type": "invalid",
      "author": "026d7a8a-12b1-4193-8a0d-415bc8f80c1a",
      "likes": 25,
      "createdAt": "2021-07-23T09:33:48Z",
      "url": "https://a.url.com/to/a/audio.aac",
      "duration": 60
    },
    {
      "type": "video",
      "likes": 2345,
      "createdAt": "2021-07-23T09:36:38Z",
      "url": "https://a.url.com/to/a/video.mp4",
      "duration": 460,
      "thumbnail": "https://a.url.com/to/a/thmbnail.png"
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

## Topics

### Protocols

- ``DynamicDecodingCollectionConfigurationProvider``

### Structures

- ``StrictCollectionConfiguration``
- ``DefaultValueCollectionConfiguration``
- ``LossyCollectionConfiguration``

### Enumerations

- ``CollectionDecodeFailConfiguration``