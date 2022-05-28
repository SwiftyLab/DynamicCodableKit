/// A property wrapper type that decodes dynamic value based on dynamic
/// decoding context provided by ``DynamicDecodingContextProvider``.
@frozen
@propertyWrapper
public struct DynamicDecodingContextBasedWrapper<
    Provider: DynamicDecodingContextProvider
>: PropertyWrapperCodable {
    /// The underlying dynamic value referenced.
    public var wrappedValue: Provider.Identified

    /// Creates new instance with a dynamic value.
    ///
    /// - Parameters:
    ///   - wrappedValue: An initial dynamic value.
    public init(wrappedValue: Provider.Identified) {
        self.wrappedValue = wrappedValue
    }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///   - decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if data is invalid or corrupt.
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try Provider.context(
            from: decoder
        ).decodeFrom(decoder)
    }
}
