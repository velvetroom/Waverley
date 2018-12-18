import AppKit

class HelpView:NSWindow {
    override var canBecomeKey:Bool { return true }
    
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:440, height:280), styleMask:
            [.unifiedTitleAndToolbar, .fullSizeContentView, .titled, .closable], backing:.buffered, defer:false)
        isReleasedWhenClosed = false
        
        let left = NSTextField()
        left.translatesAutoresizingMaskIntoConstraints = false
        left.backgroundColor = .clear
        left.isBezeled = false
        left.isEditable = false
        left.font = .editorLight(18)
        left.stringValue = .local("HelpView.text")
        contentView!.addSubview(left)
        
        let right = NSTextField()
        right.translatesAutoresizingMaskIntoConstraints = false
        right.backgroundColor = .clear
        right.isBezeled = false
        right.isEditable = false
        right.attributedStringValue = Printer.print(.local("HelpView.text"), size:18)
        contentView!.addSubview(right)
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.textColor.cgColor
        contentView!.addSubview(separator)
        
        let close = NSButton(image:NSImage(named:"button")!, target:self, action:#selector(self.close))
        close.translatesAutoresizingMaskIntoConstraints = false
        close.isBordered = false
        close.attributedTitle = NSAttributedString(string:.local("HelpView.close"), attributes:
            [.font:NSFont.systemFont(ofSize:14, weight:.medium), .foregroundColor:NSColor.black])
        close.keyEquivalent = "\u{1b}"
        contentView!.addSubview(close)
        
        left.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:40).isActive = true
        left.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:30).isActive = true
        
        right.topAnchor.constraint(equalTo:left.topAnchor).isActive = true
        right.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:30).isActive = true
        
        separator.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:30).isActive = true
        separator.bottomAnchor.constraint(equalTo:close.topAnchor, constant:-30).isActive = true
        separator.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant:1).isActive = true
        
        close.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        close.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-30).isActive = true
        center()
    }
    
    @IBAction private func showHelp(_ sender:Any?) { }
}
