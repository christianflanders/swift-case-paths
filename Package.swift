// swift-tools-version: 5.9

import CompilerPluginSupport
import Foundation
import PackageDescription

let package = Package(
  name: "swift-case-paths",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "CasePaths",
      targets: ["CasePaths"]
    )
  ],
  dependencies: [
.package(url: "https://github.com/sjavora/swift-syntax-xcframeworks.git", from: "510.0.1"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.2.2"),
  ],
  targets: [
    .target(
      name: "CasePaths",
      dependencies: [
        "CasePathsMacros",
        .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "CasePathsTests",
      dependencies: ["CasePaths"]
    ),
    .macro(
      name: "CasePathsMacros",
      dependencies: [
      .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks"),
      ]
    ),
  ]
)

#if !os(Windows)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif

if ProcessInfo.processInfo.environment["OMIT_MACRO_TESTS"] == nil {
  package.dependencies.append(
    .package(url: "https://github.com/christianflanders/swift-macro-testing", branch: "main")
  )
  package.targets.append(
    .testTarget(
      name: "CasePathsMacrosTests",
      dependencies: [
        "CasePathsMacros",
        .product(
          name: "MacroTesting",
          package: "swift-macro-testing"
        ),
      ]
    )
  )
}

for target in package.targets {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings?.append(contentsOf: [
    .enableExperimentalFeature("StrictConcurrency")
  ])
  // target.swiftSettings?.append(
  //   .unsafeFlags([
  //     "-enable-library-evolution",
  //   ])
  // )
}
