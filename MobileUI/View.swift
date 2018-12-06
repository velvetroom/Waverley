import UIKit

class View:UIViewController {
    private weak var text:UITextView!
    
    private func makeOutlets() {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.indicatorStyle = .white
        text.textColor = .white
        text.font = .systemFont(ofSize:18, weight:.light)
        text.textContainerInset = UIEdgeInsets(top:10, left:15, bottom:20, right:15)
        text.isEditable = false
        view.addSubview(text)
        self.text = text
    }
}
