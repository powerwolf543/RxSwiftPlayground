// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v13), .macOS(.v10_15),
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.1.1"),
    ],
    targets: [
        .target(name: "Networking", dependencies: ["RxSwift"]),
    ]
)
