// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftUIQuery",
  platforms: [.iOS(.v14), .macOS(.v11), .macCatalyst(.v14), .tvOS(.v14), .watchOS(.v7)],
  products: [
    .library(
      name: "SwiftUIQuery",
      targets: ["SwiftUIQuery"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SwiftUIQuery",
      dependencies: []),
    .testTarget(
      name: "SwiftUIQueryTests",
      dependencies: ["SwiftUIQuery"]),
  ]
)
