// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ImageLoader",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "ImageLoader", targets: ["ImageLoader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", .exact("6.0.0-rc.2")),
        .package(path: "Networking"),
    ],
    targets: [
        .target(name: "ImageLoader", dependencies: ["RxSwift"]),
        .testTarget(name: "ImageLoaderTests", dependencies: [
            "ImageLoader",
            .product(name: "NetworkingTestHelpers", package: "Networking"),
        ])
    ]
)
