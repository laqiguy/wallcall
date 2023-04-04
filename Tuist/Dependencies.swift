import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [.remote(url: "https://github.com/RedMadRobot/apexy-ios.git", requirement: .upToNextMajor(from: "1.0.0"))],
    platforms: [.iOS]
)