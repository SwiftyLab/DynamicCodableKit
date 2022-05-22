private extension String {
    /// Returns description for type mismatch error.
    ///
    /// - Parameters:
    ///   - type: The type mismatched.
    ///
    /// - Returns: The type mismatch error description.
    static func typeMismatchDesc<T>(_ type: T.Type) -> Self {
        return "Failed to cast to \(type)"
    }
    /// Returns description for coding key not found error.
    ///
    /// - Parameters:
    ///   - type: The coding key type not found.
    ///
    /// - Returns: The coding key value not found error description.
    static func codingKeyNotFoundDesc<K>(_ type: K.Type) -> Self {
        return "CodingKey of type \(type) not found in coding path"
    }
}

extension DecodingError {
    /// Returns decoding error for type mismatch.
    ///
    /// - Parameters:
    ///   - type: The type mismatched.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: The type mismatch decoding error.
    static func typeMismatch<T>(
        _ type: T.Type,
        codingPath: [CodingKey]
    ) -> Self {
        return .typeMismatch(
            type,
            .init(
                codingPath: codingPath,
                debugDescription: .typeMismatchDesc(T.self)
            )
        )
    }
    /// Returns decoding error for coding key not found.
    ///
    /// - Parameters:
    ///   - type: The coding key type not found.
    ///   - codingPath: The path of coding keys taken to get to this point in decoding.
    ///
    /// - Returns: The coding key type value not found error.
    static func keyNotFound<K: CodingKey>(
        ofType type: K.Type,
        codingPath: [CodingKey]
    ) -> Self {
        return .valueNotFound(
            type,
            .init(
                codingPath: codingPath,
                debugDescription: .codingKeyNotFoundDesc(K.self)
            )
        )
    }
}
