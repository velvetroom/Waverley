import Cocoa
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:120, height:60) }
    var selected = false { didSet {
        if selected {
            layer!.backgroundColor = NSColor.selectedMenuItemColor.cgColor
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
        field.font = .systemFont(ofSize:14, weight:.medium)
        field.backgroundColor = .clear
        field.lineBreakMode = .byTruncatingTail
        field.isBezeled = false
        field.isEditable = false
        field.stringValue = "Hello world, lorem ipsum, dolet samont"
        addSubview(field)
        self.field = field
        
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
        field.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        field.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
