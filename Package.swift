// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileSystemAccess",
    platforms: [.macOS(.v14), .iOS(.v16)],
    products: [
        .library(
            name: "FileSystemAccess",
            targets: ["FileSystemAccess"]
        ),
    ],
    targets: [
        .target(
            name: "FileSystemAccess"
        ),
        .testTarget(
            name: "FileSystemAccessTests",
            dependencies: ["FileSystemAccess"]
        ),
    ]
)
