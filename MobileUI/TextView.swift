import UIKit

class TextView:UITextView, NSTextStorageDelegate {
    static let lineHeight:CGFloat = 46
    private weak var caretX:NSLayoutConstraint!
    private weak var caretY:NSLayoutConstraint!
    
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
        tintColor = .scotBlue
        alwaysBounceVertical = true
        textColor = .white
        returnKeyType = .default
        keyboardAppearance = .dark
        autocorrectionType = .yes
        spellCheckingType = .yes
        autocapitalizationType = .sentences
        keyboardType = .alphabet
        contentInset = .zero
        textContainerInset = UIEdgeInsets(top:30, left:15, bottom:30, right:15)
        textStorage.delegate = self
        
        let caret = UIView()
        caret.translatesAutoresizingMaskIntoConstraints = false
        caret.backgroundColor = .scotBlue
        addSubview(caret)
        
        caret.widthAnchor.constraint(equalToConstant:5).isActive = true
        caret.heightAnchor.constraint(equalToConstant:TextView.lineHeight).isActive = true
        caretX = caret.centerXAnchor.constraint(equalTo:leftAnchor, constant:-5)
        caretY = caret.centerYAnchor.constraint(equalTo:topAnchor)
        caretX.isActive = true
        caretY.isActive = true
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
        lights.forEach { storage.addAttribute(.font, value:UIFont.editorLight(28), range:$0) }
        bolds.forEach { storage.addAttribute(.font, value:UIFont.editorBold(28), range:$0) }
    }
    
    override func caretRect(for position:UITextPosition) -> CGRect {
        let rect = super.caretRect(for:position)
        caretX.constant = rect.midX + 2
        caretY.constant = rect.midY
        return .zero
    }
}
