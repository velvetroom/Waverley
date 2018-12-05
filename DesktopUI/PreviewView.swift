import AppKit
import Desktop

class PreviewView:NSWindow {
    private weak var note:Note!
    override var canBecomeKey:Bool { return true }
    
    init(_ note:Note) {
        self.note = note
        super.init(contentRect:NSRect(x:0, y:0, width:612, height:500), styleMask:
            [.fullSizeContentView], backing:.buffered, defer:false)
        
        let cancel = NSButton(title:.local("PreviewView.cancel"), target:self, action:#selector(self.cancel))
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:14, weight:.medium)
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let pdf = NSButton(image:NSImage(named:"button")!, target:self, action:#selector(self.pdf))
        pdf.isBordered = false
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.imageScaling = .scaleNone
        pdf.keyEquivalent = "\r"
        pdf.attributedTitle = NSAttributedString(string:.local("DeleteView.delete"), attributes:
            [.font:NSFont.systemFont(ofSize:14, weight:.medium), .foregroundColor:NSColor.black])
        contentView!.addSubview(pdf)
        
        let scroll = NSScrollView(frame:.zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.drawsBackground = false
        contentView!.addSubview(scroll)
        
        let text = NSTextView(frame:NSRect(x:0, y:0, width:470, height:0))
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.drawsBackground = false
        text.isEditable = false
        text.isRichText = false
        text.textStorage!.append(Markdown().parse(string:note.content))
        text.textColor = .textColor
        scroll.documentView = text
        
        scroll.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:30).isActive = true
        scroll.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-90).isActive = true
        scroll.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:71).isActive = true
        scroll.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-71).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:40).isActive = true
        cancel.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        
        pdf.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-30).isActive = true
        pdf.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-40).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(Application.window.attachedSheet!, returnCode:.cancel)
    }
    
    @objc private func pdf() {
    }
}
