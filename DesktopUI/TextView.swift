import AppKit

class TextView:NSTextView, NSLayoutManagerDelegate {
    private weak var caretX:NSLayoutConstraint!
    private weak var caretY:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        isVerticallyResizable = true
        isContinuousSpellCheckingEnabled = true
        font = NSFont(name:"SourceCodeRoman-Light", size:18)
        allowsUndo = true
        drawsBackground = false
        layoutManager!.delegate = self
        
        let caret = NSView()
        caret.translatesAutoresizingMaskIntoConstraints = false
        caret.wantsLayer = true
        caret.layer!.backgroundColor = NSColor.scotBlue.cgColor
        addSubview(caret)
        
        caret.widthAnchor.constraint(equalToConstant:5).isActive = true
        caret.heightAnchor.constraint(equalToConstant:36).isActive = true
        caretX = caret.centerXAnchor.constraint(equalTo:leftAnchor)
        caretY = caret.centerYAnchor.constraint(equalTo:topAnchor)
        caretX.isActive = true
        caretY.isActive = true
    }
    
    func layoutManager(_:NSLayoutManager, shouldSetLineFragmentRect rect:UnsafeMutablePointer<NSRect>,
                       lineFragmentUsedRect:UnsafeMutablePointer<NSRect>, baselineOffset
        base:UnsafeMutablePointer<CGFloat>, in:NSTextContainer, forGlyphRange:NSRange) -> Bool {
        base.pointee = base.pointee + ((36 - rect.pointee.size.height) / 2)
        rect.pointee.size.height = 36
        lineFragmentUsedRect.pointee.size.height = 36
        return true
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
