import AppKit

class TextView:NSTextView {
    init() {
        super.init(frame:.zero)
        isVerticallyResizable = true
        isContinuousSpellCheckingEnabled = true
        font = NSFont(name:"SourceCodeRoman-Light", size:18)
        allowsUndo = true
        drawsBackground = false
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame:frameRect, textContainer:container)
    }
    
    required init?(coder:NSCoder) { return nil }
}
