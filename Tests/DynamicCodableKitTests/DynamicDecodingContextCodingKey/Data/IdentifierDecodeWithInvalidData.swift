let identifierDecodeWithInvalidData =
    """
    {
      "content": {
        "id": "4c76f901-3c4f-482c-8663-600a73416773",
        "type": "invalid",
        "author": "026d7a8a-12b1-4193-8a0d-415bc8f80c1a",
        "likes": 25,
        "createdAt": "2021-07-23T09:33:48Z",
        "url": "https://a.url.com/to/a/audio.aac",
        "duration": 60
      },
      "next": "https://a.url.com/to/next/page"
    }
    """.data(using: .utf8)!
