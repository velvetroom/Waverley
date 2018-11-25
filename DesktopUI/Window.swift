import Cocoa

class Window:NSWindow {
    private weak var view:View! { return contentView as? View }
    
    @IBAction private func toggle(list:NSButton) {
        if list.state == .on {
            view.showList()
        } else {
            view.hideList()
        }
    }
    
    @IBAction private func new(note:NSButton) {
        note.isEnabled = false
        view.new()
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.6) {
            note.isEnabled = true
        }
    }
}
