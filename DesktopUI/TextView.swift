import AppKit

class TextView:NSTextView, NSTextStorageDelegate {
    static let lineHeight:CGFloat = 36

    init() {
        let container = NSTextContainer()
        let storage = NSTextStorage()
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
        storage.delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
        rect.size.width = 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
    
    func textStorage(_ storage:NSTextStorage, didProcessEditing:NSTextStorageEditActions, range:NSRange,
                     changeInLength:Int) {
        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        var lights = [NSRange]()
        var bolds = [NSRange]()
        var start = storage.string.startIndex
        while let index = storage.string[start...].firstIndex(of:"#") {
            lights.append(NSRange(start..<index, in:storage.string))
            if let endHeading = storage.string[index...].firstIndex(of:"\n") {
                bolds.append(NSRange(index...endHeading, in:storage.string))
                start = endHeading
            } else {
                bolds.append(NSRange(index..., in:storage.string))
                start = storage.string.endIndex
            }
        }
        lights.append(NSRange(start..., in:storage.string))
        lights.forEach { storage.addAttribute(.font, value:NSFont.editorLight(18), range:$0) }
        bolds.forEach { storage.addAttribute(.font, value:NSFont.editorBold(18), range:$0) }
    }
}
