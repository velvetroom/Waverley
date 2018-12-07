import UIKit

class View:UIViewController, UITextViewDelegate {
    private weak var text:TextView!
    private weak var keyList:UIButton!
    private weak var accessoryBottom:NSLayoutConstraint!
    private weak var accessoryHeight:NSLayoutConstraint!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        listenKeyboard()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        text.becomeFirstResponder()
    }
    
    func textViewShouldBeginEditing(_:UITextView) -> Bool {
        if keyList.isSelected {
            list()
        }
        return true
    }
    
    private func makeOutlets() {
        let text = TextView()
        text.delegate = self
        view.addSubview(text)
        self.text = text
        
        let accessory = UIView()
        accessory.translatesAutoresizingMaskIntoConstraints = false
        accessory.backgroundColor = .scottShade
        view.addSubview(accessory)
        
        let keyList = UIButton()
        keyList.addTarget(self, action:#selector(list), for:.touchUpInside)
        keyList.translatesAutoresizingMaskIntoConstraints = false
        keyList.setImage(#imageLiteral(resourceName: "listOn.pdf"), for:.selected)
        keyList.setImage(#imageLiteral(resourceName: "listOn.pdf"), for:.highlighted)
        keyList.setImage(#imageLiteral(resourceName: "listOff.pdf"), for:.normal)
        keyList.imageView!.clipsToBounds = true
        keyList.imageView!.contentMode = .center
        accessory.addSubview(keyList)
        self.keyList = keyList
        
        text.bottomAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        
        accessory.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        accessory.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        accessoryHeight = accessory.heightAnchor.constraint(equalToConstant:54)
        
        keyList.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyList.leftAnchor.constraint(equalTo:accessory.leftAnchor).isActive = true
        keyList.widthAnchor.constraint(equalToConstant:62).isActive = true
        keyList.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        if #available(iOS 11.0, *) {
            text.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
            text.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
            
            accessoryBottom = accessory.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            text.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
            text.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
            
            accessoryBottom = accessory.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        }
        
        accessoryHeight.isActive = true
        accessoryBottom.isActive = true
    }
    
    private func listenKeyboard() {
        NotificationCenter.default.addObserver(
            forName:UIResponder.keyboardWillChangeFrameNotification, object:nil, queue:.main) {
                if let rect = ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                    rect.minY < self.view.bounds.height {
                    self.accessoryBottom.constant = -rect.height
                } else {
                    self.accessoryBottom.constant = 0
                }
                UIView.animate(withDuration:
                ($0.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0) {
                        self.view.layoutIfNeeded()
                }
        }
    }
    
    @objc private func list() {
        keyList.isSelected.toggle()
        if keyList.isSelected {
            text.resignFirstResponder()
            accessoryHeight.constant = 300
        } else {
            accessoryHeight.constant = 54
            text.becomeFirstResponder()
        }
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
