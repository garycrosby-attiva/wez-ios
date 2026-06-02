// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WezKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v13)
    ],
    products: [
        .library(name: "WezSpecs", targets: ["WezSpecs"]),
        .library(name: "WezImplementations", targets: ["WezImplementations"]),
        .library(name: "WezTestSupport", targets: ["WezTestSupport"]),
    ],
    targets: [
        .target(name: "WezSpecs"),
        .target(
            name: "WezImplementations",
            dependencies: ["WezSpecs"]
        ),
        .target(
            name: "WezTestSupport",
            dependencies: ["WezSpecs"]
        ),
        .testTarget(
            name: "WezImplementationsTests",
            dependencies: ["WezImplementations", "WezTestSupport"]
        ),
    ]
)
