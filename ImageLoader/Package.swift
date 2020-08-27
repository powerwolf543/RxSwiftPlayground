// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "ImageLoader",
    platforms: [
        .iOS(.v13), .macOS(.v10_15),
    ],
    products: [
        .library(name: "ImageLoader", targets: ["ImageLoader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.1.1"),
    ],
    targets: [
        .target(name: "ImageLoader", dependencies: ["RxSwift"]),
        .testTarget(name: "ImageLoaderTests", dependencies: ["ImageLoader"])
    ]
)
