import Cocoa

@NSApplicationMain class Application:NSObject, NSApplicationDelegate {
    private(set) static weak var window:Window!

    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    func applicationDidFinishLaunching(_:Notification) {
        Application.window = NSApp.windows.first as? Window
    }
}
