import Cocoa
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:120, height:70) }
    var selected = false { didSet {
        if selected {
            layer!.backgroundColor = NSColor.scotBlue.cgColor
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
        }
    } }
    
    override func mouseDown(with:NSEvent) {
        if !selected {
            sendAction(action, to:target)
        }
    }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let field = NSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize:11, weight:.light)
        field.backgroundColor = .clear
        field.lineBreakMode = .byWordWrapping
        field.isBezeled = false
        field.isEditable = false
        field.stringValue = note.content
        addSubview(field)
        self.field = field
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
        field.widthAnchor.constraint(equalToConstant:100).isActive = true
        field.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
