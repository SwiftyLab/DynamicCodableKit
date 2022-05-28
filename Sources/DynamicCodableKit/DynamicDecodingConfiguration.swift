/// A type that can be dynamically casted to multiple type,
/// allowing dynamic decoding.
public protocol DynamicDecodingDefaultValueProvider {
    /// A type representing the stored value.
    associatedtype Wrapped
    /// Creates an instance that stores the given value.
    ///
    /// - Parameters:
    ///   - wrapped: The value to wrap/store.
    init(_ wrapped: Wrapped)
    /// Default value to use when decoding fails.
    static var `default`: Self { get }
}

extension Optional: DynamicDecodingDefaultValueProvider {
    /// Use `nil` as default value when decoding
    /// ``DynamicDecodingDefaultValueProvider/Wrapped`` type fails.
    public static var `default`: Self { nil }
}

/// Available dynamic array decoding configuration.
@frozen
public enum CollectionDecodeFailConfiguration {
    /// Throw error if decoding fails.
    case `throw`
    /// Use default value if decoding fails.
    case `deafult`
    /// Ignore elements with invalid or corrupt data.
    case lossy
}

/// A type that can be initialized with a finite sequence of items.
public protocol SequenceInitializable {
    /// A type representing the sequence’s elements.
    associatedtype Element
    /// Creates a new instance, from no collection item.
    init()
    /// Creates a new instance from a finite sequence of items.
    ///
    /// - Parameters:
    ///   - sequence: The elements to use as members of the new instance.
    init<S>(_ sequence: S) where S: Sequence, Element == S.Element
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool { get }
}

extension Array: SequenceInitializable {}
extension Set: SequenceInitializable {}

/// A type that provides configuration for dynamic array decoding.
public protocol DynamicDecodingCollectionConfigurationProvider {
    /// Configuration to use if decoding fails.
    static var failConfig: CollectionDecodeFailConfiguration { get }
}

/// Provides strict configuration for dynamic array decoding,
/// throw error if decoding fails.
@frozen
public struct StrictCollectionConfiguration: DynamicDecodingCollectionConfigurationProvider {
    /// Use ``CollectionDecodeFailConfiguration/throw`` configuration to throw error if decoding fails.
    public static var failConfig: CollectionDecodeFailConfiguration { .throw }
}

/// Provides default configuration for dynamic array decoding,
/// use default value if decoding fails.
@frozen
public struct DefaultValueCollectionConfiguration: DynamicDecodingCollectionConfigurationProvider {
    /// Use ``CollectionDecodeFailConfiguration/deafult`` configuration
    /// to use default empty collection value if decoding fails.
    public static var failConfig: CollectionDecodeFailConfiguration { .deafult }
}

/// Provides lossy configuration for dynamic array decoding,
/// ignore elements with invalid or corrupt data.
@frozen
public struct LossyCollectionConfiguration: DynamicDecodingCollectionConfigurationProvider {
    /// Use ``CollectionDecodeFailConfiguration/lossy`` configuration
    /// to only decode items with valid data while ignoring the rest.
    public static var failConfig: CollectionDecodeFailConfiguration { .lossy }
}
