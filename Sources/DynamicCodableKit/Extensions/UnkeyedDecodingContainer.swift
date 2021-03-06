extension UnkeyedDecodingContainer {
    /// Returns decoded valid data from container,
    /// move to decoding next item if data is invalid or corrupt.
    ///
    /// - Parameter type: The type to decode.
    ///
    /// - Returns: The decoded value or nil if decoding fails.
    mutating func lossyDecode<T: Decodable>(_ type: T.Type) -> T? {
        do { return try self.decode(T.self) }
        catch { _ = try? self.decode(AnyDecodableValue.self) }
        return nil
    }
}

/// Any value decodable type.
private struct AnyDecodableValue: Decodable {}
