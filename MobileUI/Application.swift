import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = View()
        return true
    }
    
    func applicationWillResignActive(_:UIApplication) {
        (window?.rootViewController as! View).presenter.saveIfNeeded()
    }
}
