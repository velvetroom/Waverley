import UIKit
import Mobile

class View:UIViewController, UITextViewDelegate {
    private weak var text:TextView!
    private weak var items:UIView!
    private weak var keyList:UIButton!
    private weak var indicatorTop:NSLayoutConstraint!
    private weak var accessoryBottom:NSLayoutConstraint!
    private weak var accessoryHeight:NSLayoutConstraint!
    private let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        listenKeyboard()
        presenter.notes = { self.update($0) }
        presenter.select = { self.select($0) }
        presenter.load()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        text.becomeFirstResponder()
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        (items.superview as! UIScrollView).contentSize.width = size.width
    }
    
    func textViewShouldBeginEditing(_:UITextView) -> Bool {
        if keyList.isSelected {
            list()
        }
        return true
    }
    
    func textViewDidChange(_:UITextView) {
        presenter.update(text.text)
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
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.indicatorStyle = .white
        accessory.addSubview(scroll)
        
        let items = UIView()
        items.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(items)
        self.items = items
        
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
        
        let keyNew = UIButton()
        keyNew.addTarget(self, action:#selector(new), for:.touchUpInside)
        keyNew.translatesAutoresizingMaskIntoConstraints = false
        keyNew.setImage(#imageLiteral(resourceName: "new.pdf"), for:.normal)
        keyNew.imageView!.clipsToBounds = true
        keyNew.imageView!.contentMode = .center
        accessory.addSubview(keyNew)
        
        let keyShare = UIButton()
        keyShare.addTarget(presenter, action:#selector(presenter.share), for:.touchUpInside)
        keyShare.translatesAutoresizingMaskIntoConstraints = false
        keyShare.setImage(#imageLiteral(resourceName: "share.pdf"), for:.normal)
        keyShare.imageView!.clipsToBounds = true
        keyShare.imageView!.contentMode = .center
        accessory.addSubview(keyShare)
        
        let keyDelete = UIButton()
        keyDelete.addTarget(presenter, action:#selector(presenter.delete), for:.touchUpInside)
        keyDelete.translatesAutoresizingMaskIntoConstraints = false
        keyDelete.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        keyDelete.imageView!.clipsToBounds = true
        keyDelete.imageView!.contentMode = .center
        accessory.addSubview(keyDelete)
        
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        indicator.backgroundColor = .scottBlue
        text.addSubview(indicator)
        
        text.bottomAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        
        accessory.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        accessory.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        accessoryHeight = accessory.heightAnchor.constraint(equalToConstant:54)
        
        keyList.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyList.centerXAnchor.constraint(equalTo:accessory.centerXAnchor).isActive = true
        keyList.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyList.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        keyShare.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyShare.rightAnchor.constraint(equalTo:keyNew.leftAnchor).isActive = true
        keyShare.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyShare.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        keyNew.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyNew.rightAnchor.constraint(equalTo:keyList.leftAnchor).isActive = true
        keyNew.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyNew.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        keyDelete.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyDelete.rightAnchor.constraint(equalTo:keyShare.leftAnchor).isActive = true
        keyDelete.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyDelete.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        scroll.topAnchor.constraint(equalTo:accessory.topAnchor, constant:54).isActive = true
        scroll.bottomAnchor.constraint(equalTo:accessory.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo:accessory.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:accessory.rightAnchor).isActive = true
        
        items.topAnchor.constraint(equalTo:scroll.topAnchor).isActive = true
        items.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        items.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        indicatorTop = indicator.topAnchor.constraint(equalTo:view.topAnchor, constant:-10)
        indicator.leftAnchor.constraint(equalTo:text.leftAnchor).isActive = true
        indicator.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant:10).isActive = true
        indicatorTop.isActive = true
        
        if #available(iOS 11.0, *) {
            text.contentInsetAdjustmentBehavior = .never
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
    
    private func update(_ notes:[Note]) {
        items.subviews.forEach { $0.removeFromSuperview() }
        var top = items.topAnchor
        notes.forEach {
            let item = ItemView($0)
            item.addTarget(self, action:#selector(select(item:)), for:.touchUpInside)
            items.addSubview(item)
            
            item.topAnchor.constraint(equalTo:top).isActive = true
            item.leftAnchor.constraint(equalTo:items.leftAnchor).isActive = true
            item.rightAnchor.constraint(equalTo:items.rightAnchor).isActive = true
            top = item.bottomAnchor
        }
        items.bottomAnchor.constraint(equalTo:top).isActive = true
        (items.superview as! UIScrollView).contentSize.width = view.bounds.width
        (items.superview as! UIScrollView).contentSize.height = (CGFloat(items.subviews.count) * 54) + 20
    }
    
    private func select(_ note:Note) {
        let item = items.subviews.first { ($0 as! ItemView).note === note } as! ItemView
        select(item:item)
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
    
    @objc private func select(item:ItemView) {
        presenter.selected = item
        text.text = item.note.content
        text.scrollRangeToVisible(NSRange())
        text.selectedRange = NSRange()
        (items.superview as! UIScrollView).scrollRectToVisible(item.frame, animated:true)
    }
    
    @objc private func new() {
        presenter.new()
        indicatorTop.constant = view.bounds.height
        (items.superview as! UIScrollView).scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:true)
        UIView.animate(withDuration:0.4, animations: {
            self.text.alpha = 0
            self.text.layoutIfNeeded()
        }) { _ in
            self.indicatorTop.constant = -10
            UIView.animate(withDuration:0.3) {
                self.text.alpha = 1
            }
        }
    }
}
