// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend", "-internalize-at-link",
        "-Xfrontend", "-lto=llvm-full",
        "-Xfrontend", "-conditional-runtime-records"
    ])
]

let linkerSettings: [LinkerSetting] = [
    .unsafeFlags(["-Xlinker", "-dead_strip"])
]

let package = Package(
    name: "GodotApplePlugins",
    platforms: [
        .iOS(.v17),
        .macOS("14.0"),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "GodotApplePlugins",
            type: .dynamic,
            targets: ["GodotApplePlugins"]
        ),
        .executable(
            name: "GodotApplePluginsStubGenerator",
            targets: ["GodotApplePluginsStubGenerator"]
        ),
    ],
    dependencies: [
        // BeatCells patch: use local SwiftGodot submodule (shared by all
        // SwiftGodot-based plugins: godot-iap, godot-google-signin,
        // godot-connection-state, godot-app-integrity, GodotApplePlugins).
        // Combined with SwiftGodotRuntime (dynamic) below, this ensures a
        // single SwiftGodotRuntime.framework is bundled at the host project
        // level — no duplicate class conflicts at runtime.
        //
        // Upstream default is pinned URL + SwiftGodotRuntimeStatic. Keep this
        // patch on future upstream merges; see commit a20bb2e for context.
        .package(name: "SwiftGodot", path: "../SwiftGodot")
    ],
    targets: [
        .target(
            name: "GodotApplePlugins",
            dependencies: [
                .product(name: "SwiftGodotRuntime", package: "SwiftGodot")
            ],
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
        .executableTarget(
            name: "GodotApplePluginsStubGenerator"
        ),
    ]
)
