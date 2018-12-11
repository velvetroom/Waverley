import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    private(set) static weak var window:Window!

    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    func applicationDidFinishLaunching(_:Notification) {
        Application.window = NSApp.windows.first as? Window
        Application.window.delegate = self
        Application.window.backgroundColor = .textBackgroundColor
    }
    
    func applicationWillTerminate(_:Notification) {
        Application.window.view.presenter.saveIfNeeded()
    }
    
    func window(_ window:NSWindow, willPositionSheet sheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.x += ((window.frame.width - sheet.frame.width) / 2.0) - 1
        rect.origin.y += 36
        return rect
    }
}
