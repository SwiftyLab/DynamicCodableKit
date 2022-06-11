let identifierDecode =
    """
    {
      "content": {
        "id": "98765432-abcd-efab-0123-456789abcdef",
        "type": "video",
        "author": "04355678-abcd-efab-0123-456789abcdef",
        "likes": 2345,
        "createdAt": "2021-07-23T09:36:38Z",
        "url": "https://a.url.com/to/a/video.mp4",
        "duration": 460,
        "thumbnail": "https://a.url.com/to/a/thumbnail.png"
      },
      "next": "https://a.url.com/to/next/page"
    }
    """.data(using: .utf8)!

let identifierMetaDecode =
    """
    {
      "content": {
        "id": "98765432-abcd-efab-0123-456789abcdef",
        "type": "video",
        "author": "04355678-abcd-efab-0123-456789abcdef",
        "likes": 2345,
        "createdAt": "2021-07-23T09:36:38Z",
        "metadata": {
          "url": "https://a.url.com/to/a/video.mp4",
          "duration": 460,
          "thumbnail": "https://a.url.com/to/a/thumbnail.png"
        }
      },
      "next": "https://a.url.com/to/next/page"
    }
    """.data(using: .utf8)!
