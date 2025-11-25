// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VaporDockerExample",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Redis", package: "redis")
            ],
            path: "Sources/App"
        ),
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "App")
            ],
            path: "Sources/Run"
        )
    ]
)
