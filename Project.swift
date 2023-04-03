import ProjectDescription

let project = Project(
    name: "WallCal",
    organizationName: "Redmadrobot OOO",
    targets: [
        Target(
            name: "WallCall",
            platform: .iOS,
            product: .app,
            bundleId: "com.redmadrobot.wallcal",
            infoPlist: "Supporting Files/Info.plist",
            sources: [
                "Sources/**"
            ],
            resources: [
                "Supporting Files/Resources/**"],
            copyFiles: [
                .resources(name: "Supporting Files/Resources/GoogleService-Info.plist", files: []),
                .resources(name: "Supporting Files/Resources/Launch Screen.storyboard", files: [])],
            headers: .headers(
                public: ["Sources/public/A/**", "Sources/public/B/**"],
                private: "Sources/private/**",
                project: ["Sources/project/A/**", "Sources/project/B/**"]
            ),
            dependencies: [
                .external(name: "FirebaseAnalytics")
                /* Target dependencies can be defined here */
                /* .framework(path: "framework") */
            ],
            settings: .settings(
                configurations: [
                    .debug(name: .debug, xcconfig: .relativeToManifest("WallCalDebug.xcconfig")),
                    .release(name: .release, xcconfig: .relativeToManifest("WallCalRelease.xcconfig"))
                ])
        )
    ]
)
