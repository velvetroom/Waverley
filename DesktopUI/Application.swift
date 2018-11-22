import Cocoa

@NSApplicationMain class Application:NSObject, NSApplicationDelegate {
    private(set) static weak var window:NSWindow!

    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    func applicationDidFinishLaunching(_:Notification) {
        Application.window = NSApp.windows.first
    }
}
