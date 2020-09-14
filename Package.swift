// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZKUtil",
    /// 支持平台多少版本以上
    platforms: [
            .iOS(.v10),
    //        .macOS(.v10_12),
    //        .tvOS(.v10),
    //        .watchOS()
        ],
    /// 该库的一些配置
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ZKUtil",
            // 动态库 or 静态库
            // 默认为 静态库
            type: .static,
            targets: ["ZKUtil"]),
    ],
    /// 依赖那些第三方
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // 第三方有良好的版本格式: 大版本.小版本.测试版本
        // 就可以直接用这个
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: .init(5, 0, 1)),
        
        // 如果第三方版本格式, 是其他的, 例如 1.2, 根本没用第三位, 那么我们也可以这样, 直接传入字符串
        // .package(url: "https://github.com/SnapKit/SnapKit.git", from: .init(stringLiteral: "5.0.1")),
        
        // 如果第三方目前的 release 版本还没支持 SPM 的话, 我们可以直接指向他的 master 分支
        // .package(url: "https://github.com/SnapKit/SnapKit.git", Package.Dependency.Requirement.branch("master")),
        
        // 当然, 也能关联本地的能支持 SwiftPM 的库
        // .package(path: "../XQSwiftPMTest"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        // 你库的 target
        .target(
            name: "ZKUtil",
            dependencies: [
                // 你关联的第三方
                "SnapKit",
            ]),
        // 测试的 target
        .testTarget(
            name: "ZKUtilTests",
            dependencies: ["ZKUtil"]),
    ],
    // 库支持 Swift 语言版本
    swiftLanguageVersions: [
        .v5
    ]
)
