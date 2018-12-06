import UIKit

class View:UIViewController, NSTextStorageDelegate {
    private weak var text:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
    }
    
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
    
    private func makeOutlets() {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.indicatorStyle = .white
        text.tintColor = .scotBlue
        text.alwaysBounceVertical = true
        text.textColor = .white
        text.returnKeyType = .default
        text.keyboardAppearance = .dark
        text.autocorrectionType = .yes
        text.spellCheckingType = .yes
        text.autocapitalizationType = .sentences
        text.keyboardType = .alphabet
        text.contentInset = .zero
        text.textContainerInset = UIEdgeInsets(top:30, left:15, bottom:30, right:15)
        text.textStorage.delegate = self
        view.addSubview(text)
        self.text = text
        
        if #available(iOS 11.0, *) {
            text.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
            text.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            text.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            text.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
            text.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
            text.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        }
    }
}
