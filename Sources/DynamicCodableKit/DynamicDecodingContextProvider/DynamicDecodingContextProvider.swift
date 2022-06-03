/// A type that decides dynamic decoding context based on provided `Decoder`.
public protocol DynamicDecodingContextProvider {
    /// The base type or base element type in case of collection, that will be decoded.
    associatedtype Identified
    /// Decides dynamic decoding context based on provided `Decoder`.
    ///
    /// - Parameters:
    ///   - decoder: The `Decoder` to analyse.
    ///
    /// - Returns: Dynamic decoding context to use on `decoder`.
    static func context(
        from decoder: Decoder
    ) throws -> DynamicDecodingContext<Identified>
}

/// A ``DynamicDecodingContextProvider`` type that decides dynamic decoding context
/// based on decoding context contained by ``infoKey``.
public protocol UserInfoDynamicDecodingContextProvider:
    DynamicDecodingContextProvider
{
    /// User info key that contains decoding context to use.
    static var infoKey: CodingUserInfoKey { get }
}

public extension UserInfoDynamicDecodingContextProvider {
    /// Provides dynamic decoding context contained in `Decoder`'s
    /// `userInfo` property for key ``infoKey``.
    ///
    /// - Parameters:
    ///   - decoder: The `Decoder` to analyse.
    ///
    /// - Returns: Dynamic decoding context to use on `decoder`.
    static func context(
        from decoder: Decoder
    ) throws -> DynamicDecodingContext<Identified> {
        guard
            let context = decoder.userInfo[infoKey]
                as? DynamicDecodingContext<Identified>
        else {
            throw decoder.typeMismatch(Identified.self)
        }
        return context
    }
}
