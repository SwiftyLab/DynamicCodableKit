/// A property wrapper type that decodes dynamic value in a no throw approach based on
/// dynamic decoding context provided by ``DynamicDecodingContextProvider``.
///
/// This can be used as an alternative to ``DynamicDecodingContextBasedWrapper``
/// where instead of throwing error when decoding fails,
/// ``DynamicDecodingDefaultValueProvider/default`` value provided by
/// ``DynamicDecodingDefaultValueProvider`` is used,
/// i.e. ``OptionalDynamicDecodingContextBasedWrapper`` uses `nil`
/// as default value in case of failure.
@frozen
@propertyWrapper
public struct DynamicDecodingDefaultValueContextBasedWrapper<
    Provider: DynamicDecodingContextProvider,
    Wrapped: DynamicDecodingDefaultValueProvider
>: Decodable where Wrapped.Wrapped == Provider.Identified {
    /// The underlying ``DynamicDecodingDefaultValueProvider``
    /// that wraps dynamic value value referenced.
    public var wrappedValue: Wrapped

    /// Creates new instance with an underlying dynamic wrapped value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial value with wrapped dynamic value.
    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    public init(from decoder: Decoder) {
        guard
            let value = try? Provider.context(from: decoder).decodeFrom(decoder)
        else {
            self.wrappedValue = .default
            return
        }
        self.wrappedValue = .init(value)
    }
}

/// A property wrapper type that decodes optional dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider``.
///
/// `OptionalDynamicDecodingContextBasedWrapper` is a type alias for
/// ``DynamicDecodingDefaultValueContextBasedWrapper``,
/// with wrapped value as optional dynamic value. If decoding fails,
/// `nil` is used as underlying value instead of throwing error.
public typealias OptionalDynamicDecodingContextBasedWrapper<
    Provider: DynamicDecodingContextProvider
> = DynamicDecodingDefaultValueContextBasedWrapper<
    Provider,
    Optional<Provider.Identified>
>
