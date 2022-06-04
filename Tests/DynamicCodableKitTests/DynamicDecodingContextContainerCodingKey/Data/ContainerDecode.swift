let containerDecode =
    """
    {
      "content": {
        "text": {
          "id": "00005678-abcd-efab-0123-456789abcdef",
          "author": "12345678-abcd-efab-0123-456789abcdef",
          "likes": 145,
          "createdAt": "2021-07-23T07:36:43Z",
          "text": "Lorem Ipsium"
        },
        "picture": {
          "id": "43215678-abcd-efab-0123-456789abcdef",
          "author": "abcd5678-abcd-efab-0123-456789abcdef",
          "likes": 370,
          "createdAt": "2021-07-23T09:32:13Z",
          "url": "https://a.url.com/to/a/picture.png",
          "caption": "Lorem Ipsium"
        },
        "audio": {
          "id": "64475bcb-caff-48c1-bb53-8376628b350b",
          "author": "4c17c269-1c56-45ab-8863-d8924ece1d0b",
          "likes": 25,
          "createdAt": "2021-07-23T09:33:48Z",
          "url": "https://a.url.com/to/a/audio.aac",
          "duration": 60
        },
        "video": {
          "id": "98765432-abcd-efab-0123-456789abcdef",
          "author": "04355678-abcd-efab-0123-456789abcdef",
          "likes": 2345,
          "createdAt": "2021-07-23T09:36:38Z",
          "url": "https://a.url.com/to/a/video.mp4",
          "duration": 460,
          "thumbnail": "https://a.url.com/to/a/thumbnail.png"
        }
      },
      "next": "https://a.url.com/to/next/page"
    }
    """.data(using: .utf8)!
