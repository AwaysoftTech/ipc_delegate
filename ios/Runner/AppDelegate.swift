import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        print("IOS STEP 1: AppDelegate launched")

        GeneratedPluginRegistrant.register(with: self)

        print("IOS STEP 2: Plugins registered")

        let result = super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        print("IOS STEP 3: Application launch completed")

        return result
    }
}