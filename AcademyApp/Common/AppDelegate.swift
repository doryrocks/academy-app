import UIKit
import Firebase

 @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let bar = TabBarVC()
        window?.rootViewController = bar
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
    }
}
