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
    
    func textStorage(_ storage:NSTextStorage, didProcessEditing editedMask:NSTextStorageEditActions, range editedRange:NSRange, changeInLength delta:Int) {
//        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        
        let greeting = "Hi there! It's nice to meet you! 👋"
        let endOfSentence = greeting.index(of: "!")!
        let firstSentence = greeting[...endOfSentence]
        // firstSentence == "Hi there!"
        var string = storage.string
//        while let range = string.range(of:"#") {
//            NSRange(Range(string.index(before:range.upperBound), in:string), in:string)
//            range.sub
//            storage.addAttribute(.font, value:NSFont(name:"SourceCodeRoman-Light", size:18), range: <#T##NSRange#>)
//            string = String(string.suffix(from:string.index(after:index)))
//        }
        
        /*
        let components = storage.string.components(separatedBy:"#")
        var length = 0
        for (index, string) in components.enumerated() {
            if index > 0 {
                NSFont(name:"SourceCodeRoman-Light", size:18)
            }
            length += string.count
        }*/
    }
}
