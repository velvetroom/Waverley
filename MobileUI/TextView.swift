import UIKit

class TextView:UITextView, NSTextStorageDelegate {
    static let lineHeight:CGFloat = 30
    
    init() {
        let container = NSTextContainer()
        let storage = NSTextStorage()
        let layout = TextLayout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        indicatorStyle = .white
        tintColor = .scottBlue
        alwaysBounceVertical = true
        textColor = .white
        returnKeyType = .default
        keyboardAppearance = .dark
        autocorrectionType = .yes
        spellCheckingType = .yes
        autocapitalizationType = .sentences
        keyboardType = .alphabet
        contentInset = .zero
        textContainerInset = UIEdgeInsets(top:16, left:10, bottom:30, right:10)
        textStorage.delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textStorage(_ storage:NSTextStorage, didProcessEditing:NSTextStorage.EditActions, range:NSRange,
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
        lights.forEach { storage.addAttribute(.font, value:UIFont.editorLight(16), range:$0) }
        bolds.forEach { storage.addAttribute(.font, value:UIFont.editorBold(16), range:$0) }
    }
    
    override func caretRect(for position:UITextPosition) -> CGRect {
        var rect = super.caretRect(for:position)
        rect.size.width = 4
        return rect
    }
}
