import AppKit
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:250, height:60) }
    var selected = false { didSet {
        if selected {
            layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        } else {
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
        field.backgroundColor = .clear
        field.lineBreakMode = .byWordWrapping
        field.isBezeled = false
        field.isEditable = false
        field.font = .systemFont(ofSize:12, weight:.ultraLight)
        field.alphaValue = 0.7
        addSubview(field)
        self.field = field
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:12).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:24).isActive = true
        field.widthAnchor.constraint(equalToConstant:195).isActive = true
        field.heightAnchor.constraint(equalToConstant:36).isActive = true
        
        update(note.content)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ content:String) {
        field.stringValue = String(content.prefix(120))
    }
    
    func search(_ term:String) {
        if let range = note.content.range(of:term, options:.caseInsensitive) {
            if range.lowerBound != note.content.startIndex {
                field.stringValue = "..."
            } else {
                field.stringValue = ""
            }
            field.stringValue += String(note.content[range.lowerBound...].prefix(100))
            field.alphaValue = 1
        } else {
            update(note.content)
            field.alphaValue = 0.2
        }
    }
    
    func clearSearch() {
        update(note.content)
        field.alphaValue = 0.7
    }
    
    override func mouseDown(with:NSEvent) {
        if !selected {
            sendAction(action, to:target)
        }
    }
}
