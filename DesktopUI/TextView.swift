import AppKit

class TextView:NSTextView {
    static let lineHeight:CGFloat = 36
    private weak var caretX:NSLayoutConstraint!
    private weak var caretY:NSLayoutConstraint!

    init() {
        let container = NSTextContainer()
        let storage = NSTextStorage()
        let layout = Layout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        isVerticallyResizable = true
        isContinuousSpellCheckingEnabled = true
        font = NSFont(name:"SourceCodeRoman-Light", size:18)
        allowsUndo = true
        drawsBackground = false
        usesFindBar = true
        isIncrementalSearchingEnabled = true
        
        let caret = NSView()
        caret.translatesAutoresizingMaskIntoConstraints = false
        caret.wantsLayer = true
        caret.layer!.backgroundColor = NSColor.scotBlue.cgColor
        addSubview(caret)
        
        caret.widthAnchor.constraint(equalToConstant:5).isActive = true
        caret.heightAnchor.constraint(equalToConstant:TextView.lineHeight).isActive = true
        caretX = caret.centerXAnchor.constraint(equalTo:leftAnchor)
        caretY = caret.centerYAnchor.constraint(equalTo:topAnchor)
        caretX.isActive = true
        caretY.isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn flag:Bool) {
        caretX.constant = rect.midX + 2
        caretY.constant = rect.midY
    }
}
