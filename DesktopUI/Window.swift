import AppKit

class Window:NSWindow {
    weak var view:View! { return contentView as? View }
    
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
    
    @IBAction private func delete(note:NSButton) {
        view.presenter.delete()
    }
    
    @IBAction private func share(note:NSButton) {
        view.presenter.share()
    }
}
