let providerCollectionDecodeWithInvalidData =
    """
    {
      "content": [
        {
          "id": "00005678-abcd-efab-0123-456789abcdef",
          "author": "12345678-abcd-efab-0123-456789abcdef",
          "likes": 145,
          "createdAt": "2021-07-23T07:36:43Z",
          "text": "Lorem Ipsium"
        },
        {
          "id": "00005678-abcd-efab-0123-456789abcdef",
          "author": "12345678-abcd-efab-0123-456789abcdef",
          "likes": 145,
          "createdAt": "2021-07-23T07:36:43Z",
          "text": "Lorem Ipsium"
        },
        {
          "id": "00005678-abcd-efab-0123-456789abcdef",
          "author": "12345678-abcd-efab-0123-456789abcdef",
          "likes": 145,
          "createdAt": "2021-07-23T07:36:43Z",
          "text": "Lorem Ipsium"
        },
        {
          "id": "98765432-abcd-efab-0123-456789abcdef",
          "author": "04355678-abcd-efab-0123-456789abcdef",
          "likes": 2345,
          "createdAt": "2021-07-23T09:36:38Z",
          "url": "https://a.url.com/to/a/video.mp4",
          "duration": 460,
          "thumbnail": "https://a.url.com/to/a/thmbnail.png"
        },
        {
          "id": "98765432-abcd-efab-0123-456789abcdef",
          "author": "04355678-abcd-efab-0123-456789abcdef",
          "likes": 2345,
          "createdAt": "2021-07-23T09:36:38Z",
          "url": "https://a.url.com/to/a/video.mp4",
          "duration": 460,
          "thumbnail": "https://a.url.com/to/a/thmbnail.png"
        },
        {
          "likes": 2345,
          "createdAt": "2021-07-23T09:36:38Z",
          "url": "https://a.url.com/to/a/video.mp4",
          "duration": 460,
          "thumbnail": "https://a.url.com/to/a/thmbnail.png"
        }
      ],
      "next": "https://a.url.com/to/next/page"
    }
    """.data(using: .utf8)!
