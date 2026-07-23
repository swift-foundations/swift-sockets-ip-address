// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-sockets-ip-address",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "Sockets IP Address", targets: ["Sockets IP Address"]),
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
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
