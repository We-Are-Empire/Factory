// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Factory",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1),
        .macCatalyst(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FactoryKit",
            targets: ["FactoryKit"]
        ),
        .library(
            name: "FactoryKitDynamic",
            type: .dynamic,
            targets: ["FactoryKit"]
        ),
        .library(
            name: "FactoryTesting",
            targets: ["FactoryTesting"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.5.0"),
        // Skip-Fuse runtime + SwiftUI shim. On Android cross-compile, these
        // bring `Observation.Observable`, `@MainActor`, `DynamicProperty`,
        // `@State`, `Binding`, and the rest of the SwiftUI surface that
        // FactoryKit's property wrappers (`@InjectedObservable`, `@Injected`,
        // etc.) reference. Without them the package is silently dropped from
        // the Android build and call-site `@InjectedObservable` becomes
        // "unknown attribute". iOS/macOS/Apple targets aren't affected — the
        // condition `.when(platforms: [.android])` keeps them out of Xcode
        // resolution.
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FactoryKit",
            dependencies: [
                .product(name: "SkipFuse", package: "skip-fuse", condition: .when(platforms: [.android])),
                .product(name: "SkipFuseUI", package: "skip-fuse-ui", condition: .when(platforms: [.android]))
            ],
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: FactorySwiftSetting.common
        ),
        .target(
            name: "FactoryTesting",
            dependencies: [
                "FactoryKit"
            ],
            swiftSettings: FactorySwiftSetting.common
        ),
        .testTarget(
            name: "FactoryTests",
            dependencies: [
                "FactoryTesting"
            ],
            swiftSettings: FactorySwiftSetting.common
        )
    ],
    swiftLanguageModes: [
        .version("6")
    ]
)

enum FactorySwiftSetting {
    static let common: [SwiftSetting] = [
        .enableExperimentalFeature("StrictConcurrency")
    ]
}
