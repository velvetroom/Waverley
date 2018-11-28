import AppKit
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var selector:NSView!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:250, height:60) }
    var selected = false { didSet { update() } }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let field = NSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.lineBreakMode = .byWordWrapping
        field.isBezeled = false
        field.isEditable = false
        field.font = .systemFont(ofSize:12, weight:.light)
        addSubview(field)
        self.field = field
        
        let selector = NSView()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.wantsLayer = true
        selector.layer!.backgroundColor = NSColor.scotBlue.cgColor
        addSubview(selector)
        self.selector = selector
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:12).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        field.widthAnchor.constraint(equalToConstant:220).isActive = true
        field.heightAnchor.constraint(equalToConstant:36).isActive = true
        
        selector.topAnchor.constraint(equalTo:topAnchor).isActive = true
        selector.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        selector.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        selector.widthAnchor.constraint(equalToConstant:2).isActive = true
        
        update(note.content)
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ content:String) {
        field.stringValue = String(content.prefix(120))
    }
    
    override func mouseDown(with:NSEvent) {
        if !selected {
            sendAction(action, to:target)
        }
    }
    
    private func update() {
        if selected {
            field.alphaValue = 1
            selector.isHidden = false
        } else {
            field.alphaValue = 0.6
            selector.isHidden = true
        }
    }
}
