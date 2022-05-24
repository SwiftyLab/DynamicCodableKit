public extension KeyedDecodingContainerProtocol {
    /// Returns decoding error for coding key not found in `codingPath`.
    ///
    /// - Parameters:
    ///   - type: The coding key type.
    ///
    /// - Returns: The value not found decoding error.
    func keyNotFound<K: CodingKey>(ofType type: K.Type) -> DecodingError {
        return .keyNotFound(ofType: K.self, codingPath: codingPath)
    }
    /// Returns coding key of provided type from `codingPath`.
    ///
    /// - Parameters:
    ///   - type: The type of coding key to retrieve.
    ///
    /// - Returns: The coding key of required type in `codingPath`
    ///            or nil if found none.
    func codingKeyFromPath<K: CodingKey>(ofType type: K.Type) -> K? {
        return self.codingPath.first(where: { $0 is K }) as? K
    }
    /// Returns coding key of provided type from `codingPath`.
    ///
    /// - Parameters:
    ///   - type: The type of coding key to retrieve.
    ///
    /// - Returns: The coding key of required type in `codingPath`.
    ///
    /// - Throws: `DecodingError.valueNotFound` if coding key
    ///           of provided type not found in `codingPath`.
    func codingKeyFromPath<K: CodingKey>(ofType type: K.Type) throws -> K {
        guard
            let key = self.codingPath.first(where: { $0 is K }) as? K
        else { throw self.keyNotFound(ofType: K.self) }
        return key
    }
}
