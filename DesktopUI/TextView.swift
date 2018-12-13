import AppKit

class TextView:NSTextView {
    static let lineHeight:CGFloat = 36

    init() {
        let container = NSTextContainer()
        let storage = TextStorage()
        let layout = TextLayout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        usesFindBar = true
        isIncrementalSearchingEnabled = true
        textContainerInset.height = 50
        isRichText = false
        insertionPointColor = .scottBlue
        font = .editorLight(18)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
        rect.size.width = 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
}
