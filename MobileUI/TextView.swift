import UIKit

class TextView:UITextView {
    static let lineHeight:CGFloat = 30
    
    init() {
        let container = NSTextContainer()
        let storage = TextStorage()
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
        font = .editorLight(16)
        textContainerInset = UIEdgeInsets(top:16, left:10, bottom:30, right:10)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func caretRect(for position:UITextPosition) -> CGRect {
        var rect = super.caretRect(for:position)
        rect.size.width = 4
        return rect
    }
}
