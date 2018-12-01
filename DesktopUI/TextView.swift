import AppKit

class TextView:NSTextView, NSTextStorageDelegate {
    static let lineHeight:CGFloat = 36
    private weak var caretX:NSLayoutConstraint!
    private weak var caretY:NSLayoutConstraint!

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
        font = NSFont(name:"SourceCodeRoman-Light", size:18)
        storage.delegate = self
        
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
    
    func textStorage(_ storage:NSTextStorage, didProcessEditing editedMask:NSTextStorageEditActions, range:NSRange,
                     changeInLength:Int) {
        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        var string = storage.string
        var location = 0
        while let index = string.firstIndex(of:"#") {
            let plain = String(string[..<index])
            storage.addAttribute(.font, value:NSFont(name:"SourceCodeRoman-Light", size:18)!,
                                 range:NSMakeRange(location, plain.count))
            location += plain.count
            string = String(string[index...])
            let heading:String
            if let endHeading = string.firstIndex(of:"\n") {
                heading = String(string[..<endHeading])
                location += heading.count
                string = String(string[endHeading...])
            } else {
                heading = string
                string = String()
            }
            storage.addAttribute(.font, value:NSFont(name:"SourceCodeRoman-Bold", size:18)!,
                                 range:NSMakeRange(location, heading.count))
        }
        if location == 0 {
            storage.addAttribute(.font, value:NSFont(name:"SourceCodeRoman-Light", size:18)!,
                                 range:NSMakeRange(location, storage.string.count))
        }
    }
}
