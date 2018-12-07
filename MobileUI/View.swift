import UIKit

class View:UIViewController {
    private weak var text:TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        text.becomeFirstResponder()
    }
    
    private func makeOutlets() {
        let text = TextView()
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
