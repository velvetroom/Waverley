import AppKit

class DeleteView:NSWindow {
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:180, height:140), styleMask:
            [.titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing:.buffered, defer:false)
        let background = NSView(frame:.zero)
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.textBackgroundColor.cgColor
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(background)
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.alignment = .center
        title.font = NSFont(name:"SourceCodeRoman-Medium", size:17)!
        title.stringValue = .local("DeleteView.title")
        contentView!.addSubview(title)
        
        let cancel = NSButton(title:.local("DeleteView.cancel"), target:self, action:#selector(self.cancel))
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = NSFont(name:"SourceCodeRoman-Light", size:14)!
        contentView!.addSubview(cancel)
        
        let delete = NSButton(title:.local("DeleteView.delete"), target:self, action:#selector(self.delete))
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.font = NSFont(name:"SourceCodeRoman-Light", size:14)!
        contentView!.addSubview(delete)
        
        background.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:15).isActive = true
        title.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        
        cancel.bottomAnchor.constraint(equalTo:delete.topAnchor, constant:-15).isActive = true
        cancel.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        
        delete.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        delete.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.cancel)
    }
    
    @objc private func delete() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.continue)
    }
}
