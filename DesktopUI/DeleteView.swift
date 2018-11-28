import AppKit

class DeleteView:NSWindow {
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:240, height:100), styleMask:
            [.fullSizeContentView], backing:.buffered, defer:false)
        let background = NSView()
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.textBackgroundColor.cgColor
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(background)
        
        let cancel = NSButton(title:.local("DeleteView.cancel"), target:self, action:#selector(self.cancel))
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:14, weight:.medium)
        contentView!.addSubview(cancel)
        
        let delete = NSButton(image:NSImage(named:"button")!, target:self, action:#selector(self.delete))
        delete.isBordered = false
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.imageScaling = .scaleNone
        delete.attributedTitle = NSAttributedString(string:.local("DeleteView.delete"), attributes:
            [.font:NSFont.systemFont(ofSize:14, weight:.medium), .foregroundColor:NSColor.black])
        contentView!.addSubview(delete)
        
        background.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:40).isActive = true
        cancel.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        
        delete.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-40).isActive = true
        delete.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.cancel)
    }
    
    @objc private func delete() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.continue)
    }
}
