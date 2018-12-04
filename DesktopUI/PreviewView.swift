import AppKit
import Desktop

class PreviewView:NSWindow {
    private weak var note:Note!
    override var canBecomeKey:Bool { return true }
    
    init(_ note:Note) {
        self.note = note
        super.init(contentRect:NSRect(x:0, y:0, width:616, height:500), styleMask:
            [.fullSizeContentView], backing:.buffered, defer:false)
        let background = NSView()
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.textBackgroundColor.cgColor
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(background)
        
        let sheet = NSView()
        sheet.wantsLayer = true
        sheet.layer!.backgroundColor = NSColor.white.cgColor
        sheet.layer!.cornerRadius = 10
        sheet.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(sheet)
        
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
        
        let scroll = NSScrollView(frame:.zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.drawsBackground = false
        sheet.addSubview(scroll)
        
        let text = NSTextView(frame:NSRect(x:0, y:0, width:470, height:0))
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.drawsBackground = false
        text.isEditable = false
        text.isRichText = false
        text.textStorage!.append(Markdown().parse(string:note.content))
        scroll.documentView = text
        
        background.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        
        sheet.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:2).isActive = true
        sheet.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-60).isActive = true
        sheet.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:2).isActive = true
        sheet.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-2).isActive = true
        
        scroll.topAnchor.constraint(equalTo:sheet.topAnchor, constant:71).isActive = true
        scroll.bottomAnchor.constraint(equalTo:sheet.bottomAnchor, constant:-71).isActive = true
        scroll.leftAnchor.constraint(equalTo:sheet.leftAnchor, constant:71).isActive = true
        scroll.rightAnchor.constraint(equalTo:sheet.rightAnchor, constant:-71).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:40).isActive = true
        cancel.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        
        delete.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-40).isActive = true
        delete.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.cancel)
    }
    
    @objc private func delete() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.continue)
    }
}
