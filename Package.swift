// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Treesquid",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Treesquid",
            targets: ["Treesquid"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Treesquid",
            dependencies: [],
            exclude: [
                "Resources/logo-square-240-240.png",
                "Resources/logo-wide-1200-240.png"
            ]),
        .testTarget(
            name: "TreesquidTests",
            dependencies: ["Treesquid"]),
    ]
)
