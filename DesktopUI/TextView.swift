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

    
    func a(_ notification: Notification) {
        let storage = notification.object as! NSTextStorage
        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        let ranges = self.makeRanges(storage.string)
        
        ranges.0.forEach { storage.addAttribute(.font, value:NSFont.editorLight(18), range:$0) }
        ranges.1.forEach { storage.addAttribute(.font, value:NSFont.editorBold(18), range:$0) }

    }
    
    /*
    
    func textStorage(_ storage:NSTextStorage, didProcessEditing actions:NSTextStorageEditActions, range:NSRange,
                     changeInLength:Int) {
        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        let ranges = self.makeRanges(storage.string)
        
        ranges.0.forEach { storage.addAttribute(.font, value:NSFont.editorLight(18), range:$0) }
        ranges.1.forEach { storage.addAttribute(.font, value:NSFont.editorBold(18), range:$0) }
        if actions == .editedCharacters {
            
            DispatchQueue.global(qos:.background).async {
                
                DispatchQueue.main.async {
                    
                }
            }
            print("char")
        } else {
            print("attributes")
        }
    }*/
    
    private func makeRanges(_ string:String) -> ([NSRange], [NSRange]) {
        var lights = [NSRange]()
        var bolds = [NSRange]()
        var start = string.startIndex
        while let index = string[start...].firstIndex(of:"#") {
            lights.append(NSRange(start..<index, in:string))
            if let endHeading = string[index...].firstIndex(of:"\n") {
                bolds.append(NSRange(index...endHeading, in:string))
                start = endHeading
            } else {
                bolds.append(NSRange(index..., in:string))
                start = string.endIndex
            }
        }
        lights.append(NSRange(start..., in:string))
        return (lights, bolds)
    }
}
