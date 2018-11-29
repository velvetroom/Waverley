import AppKit

class Window:NSWindow {
    weak var view:View! { return contentView as? View }
    @IBOutlet private weak var list:NSButton!
    
    @IBAction private func toggleSourceList(_ sender:NSMenuItem) {
        switch list.state {
        case .on:
            sender.title = .local("Window.showList")
            list.state = .off
        default:
            sender.title = .local("Window.hideList")
            list.state = .on
        }
        toggle(list:list)
    }
    
    @IBAction private func toggle(list:NSButton) {
        if list.state == .on {
            view.showList()
        } else {
            view.hideList()
        }
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        let button = sender as? NSButton
        button?.isEnabled = false
        view.new()
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.6) {
            button?.isEnabled = true
        }
    }
    
    @IBAction private func remove(_ sender:Any) {
        view.presenter.delete()
    }
    
    @IBAction private func play(_ sender:Any?) {
        view.presenter.share()
    }
    
    @IBAction private func goToPreviousPage(_ sender:Any) {
        view.presenter.previous()
    }
    
    @IBAction private func goToNextPage(_ sender:Any) {
        view.presenter.next()
    }
}
