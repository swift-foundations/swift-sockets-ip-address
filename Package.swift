// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-sockets-ip-address",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Sockets IP Address", targets: ["Sockets IP Address"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-sockets.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-ip-address.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Sockets IP Address",
            dependencies: [
                .product(name: "Sockets", package: "swift-sockets"),
                .product(name: "IP Address", package: "swift-ip-address"),
            ]
        ),
        .testTarget(
            name: "Sockets IP Address Tests",
            dependencies: ["Sockets IP Address"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
