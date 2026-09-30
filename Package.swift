// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-osc",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "SwiftOSC", targets: ["SwiftOSC"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-osc-core", exact: "1.4.0"),
        .package(url: "https://github.com/orchetect/swift-osc-io-nio", exact: "1.2.0")
    ],
    targets: [
        .target(
            name: "SwiftOSC",
            dependencies: [
                .product(name: "SwiftOSCCore", package: "swift-osc-core"),
                .product(name: "SwiftOSCIO", package: "swift-osc-io-nio")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        )
    ]
)

// MARK: - Utilities

func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

// MARK: - CI Pipeline

if hasEnvironmentVariable("GITHUB_ACTIONS") {
    for target in package.targets {
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
    }
}
