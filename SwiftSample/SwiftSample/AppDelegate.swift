import UIKit
//import FBSDKCoreKit
import goplaysdk

/**
  add this line to SwiftSampleApp
 @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 */
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Ví dụ: Facebook SDK khởi tạo
//        ApplicationDelegate.shared.application(
//            application,
//            didFinishLaunchingWithOptions: launchOptions
//        )

        // Khởi tạo SDK của anh
        GoPlaySDK.instance.initSDK(true, "2356aa1f65af420c","SwlDJHfkE8F8ldQr9wzwDF6jTMRG6+/5")
        return GoPlaySDK.instance.application(application, didFinishLaunchingWithOptions: launchOptions)
     
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // Facebook login callback
        return GoPlaySDK.instance.application(app, open: url, options: options)
    }
}
