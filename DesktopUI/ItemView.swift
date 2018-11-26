import Cocoa
import Desktop

class ItemView:NSControl {
    private(set) weak var note:Note!
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:120, height:50) }
    var selected = false { didSet { update() } }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let field = NSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.lineBreakMode = .byCharWrapping
        field.isBezeled = false
        field.isEditable = false
        addSubview(field)
        self.field = field
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:5).isActive = true
        field.widthAnchor.constraint(equalToConstant:110).isActive = true
        field.heightAnchor.constraint(equalToConstant:30).isActive = true
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
            field.textColor = .black
            field.font = NSFont(name:"SourceCodeRoman-Medium", size:11)!
            layer!.backgroundColor = NSColor.scotBlue.cgColor
            
        } else {
            field.textColor = .textColor
            field.font = NSFont(name:"SourceCodeRoman-ExtraLight", size:11)!
            layer!.backgroundColor = NSColor.clear.cgColor
        }
    }
}
