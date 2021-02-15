// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v13), .macOS(.v10_15),
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "NetworkingTestHelpers", targets: ["NetworkingTestHelpers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", .exact("6.1.0")),
    ],
    targets: [
        .target(name: "Networking", dependencies: ["RxSwift"]),
        .target(name: "NetworkingTestHelpers"),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking", "NetworkingTestHelpers"])
    ]
)
