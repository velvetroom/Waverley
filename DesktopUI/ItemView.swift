import Cocoa
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:120, height:50) }
    var selected = false { didSet {
        if selected {
            field.textColor = NSColor.black
            layer!.backgroundColor = NSColor.scotBlue.cgColor
        } else {
            field.textColor = NSColor.textColor
            layer!.backgroundColor = NSColor.clear.cgColor
        }
    } }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let field = NSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = NSFont(name:"SourceCodeVariable-Roman", size:10)
        field.backgroundColor = .clear
        field.lineBreakMode = .byWordWrapping
        field.isBezeled = false
        field.isEditable = false
        addSubview(field)
        self.field = field
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:5).isActive = true
        field.widthAnchor.constraint(equalToConstant:110).isActive = true
        field.heightAnchor.constraint(equalToConstant:30).isActive = true
        update(note.content)
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
}
