import Foundation

extension Bundle {
    private final class BundleClass {}

    static var module: Bundle { Bundle(for: BundleClass.self) }
}
