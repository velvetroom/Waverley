import AppKit

class DeleteView:NSWindow {
    override var canBecomeKey:Bool { return true }

    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:180, height:Application.window!.frame.height),
                   styleMask:[], backing:.buffered, defer:false)
        
        let cancel = NSButton(title:.local("DeleteView.cancel"), target:self, action:#selector(self.cancel))
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:14, weight:.medium)
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let delete = NSButton(image:NSImage(named:"button")!, target:self, action:#selector(self.delete))
        delete.isBordered = false
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.imageScaling = .scaleNone
        delete.keyEquivalent = "\r"
        delete.attributedTitle = NSAttributedString(string:.local("DeleteView.delete"), attributes:
            [.font:NSFont.systemFont(ofSize:14, weight:.medium), .foregroundColor:NSColor.black])
        contentView!.addSubview(delete)
        
        cancel.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(self, returnCode:.cancel)
    }
    
    @objc private func delete() {
        Application.window.endSheet(self, returnCode:.continue)
    }
}
