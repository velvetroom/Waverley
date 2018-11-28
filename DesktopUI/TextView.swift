import AppKit

class TextView:NSTextView {
    private weak var caretX:NSLayoutConstraint!
    private weak var caretY:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        isVerticallyResizable = true
        isContinuousSpellCheckingEnabled = true
        font = NSFont(name:"SourceCodeRoman-Light", size:18)
        allowsUndo = true
        drawsBackground = false
        
        let caret = NSView()
        caret.translatesAutoresizingMaskIntoConstraints = false
        caret.wantsLayer = true
        caret.layer!.backgroundColor = NSColor.scotBlue.cgColor
        addSubview(caret)
        
        caret.widthAnchor.constraint(equalToConstant:5).isActive = true
        caret.heightAnchor.constraint(equalToConstant:30).isActive = true
        caretX = caret.centerXAnchor.constraint(equalTo:leftAnchor)
        caretY = caret.centerYAnchor.constraint(equalTo:topAnchor)
        caretX.isActive = true
        caretY.isActive = true
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn flag:Bool) {
        caretX.constant = rect.midX + 2
        caretY.constant = rect.midY
    }
}
