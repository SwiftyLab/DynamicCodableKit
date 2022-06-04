# ``DynamicCodableKit/DynamicDecodable``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

Provides `castAs` methods to customize dynamic casting to a provided type where provided type can be optional type or collection type as well. Default implementations are provided to work well with down casting, however custom types can provide their own casting behavior.

For example, in <doc:TypeIdentifier>, to use `Set` of `Post` type instead of `Array`, a box type for `Post` type can be created that will confirm `Hashable`:
```swift
@dynamicMemberLookup
struct AnyPost<P>: Hashable {
    let value: P

    init(withValue value: P) {
        self.value = value
    }

    static func == (lhs: AnyPost<P>, rhs: AnyPost<P>) -> Bool {
        lhs.value as! AnyHashable == rhs.value as! AnyHashable
    }

    func hash(into hasher: inout Hasher) {
        (value as! AnyHashable).hash(into: &hasher)
    }

    subscript<T>(dynamicMember path: KeyPath<P,T>) -> T {
        return value[keyPath: path]
    }
}
```

and custom `castAs` implementation can be provided for casting to `AnyPost` box type:
```swift
extension DynamicDecodable where Self: Post {
    func castAs<T>(type: T.Type, codingPath: [CodingKey]) throws -> T {
        switch self {
        case let value as T:
            return value
        case _ where T.self is AnyPost<Post>.Type:
            return AnyPost(withValue: self as Post) as! T
        default:
            throw DecodingError.typeMismatch(T.self, codingPath: codingPath)
        }
    }
    func castAs<T: ExpressibleByNilLiteral>(type: T.Type, codingPath: [CodingKey]) -> T {
        return self as? T ?? AnyPost(withValue: self as Post) as? T ?? nil
    }
}
```

Finally, set of posts can be decoded with following `Decodable` model:
```swift
struct ThrowingPostPageSet: Decodable {
    let next: URL
    @StrictDynamicDecodingCollectionWrapper<PostSetCodingKey, Set<AnyPost<Post>>> var content: Set<AnyPost<Post>>
}
```
