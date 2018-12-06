import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static let navigation = UINavigationController()
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        Application.navigation.setNavigationBarHidden(true, animated:false)
        Application.navigation.setViewControllers([View()], animated:false)
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = Application.navigation
        return true
    }
}
