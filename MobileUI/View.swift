import UIKit
import Mobile

class View:UIViewController, UITextViewDelegate {
    let presenter = Presenter()
    private weak var text:TextView!
    private weak var items:UIView!
    private weak var keyList:UIButton!
    private weak var indicatorTop:NSLayoutConstraint!
    private weak var accessoryBottom:NSLayoutConstraint!
    private weak var accessoryHeight:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        listenKeyboard()
        presenter.update = { self.update($0) }
        presenter.select = { self.select($0) }
        presenter.scrollToTop = { self.scrollToTop() }
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
        keyShare.addTarget(self, action:#selector(share), for:.touchUpInside)
        keyShare.translatesAutoresizingMaskIntoConstraints = false
        keyShare.setImage(#imageLiteral(resourceName: "share.pdf"), for:.normal)
        keyShare.imageView!.clipsToBounds = true
        keyShare.imageView!.contentMode = .center
        accessory.addSubview(keyShare)
        
        let keyDelete = UIButton()
        keyDelete.addTarget(self, action:#selector(remove), for:.touchUpInside)
        keyDelete.translatesAutoresizingMaskIntoConstraints = false
        keyDelete.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        keyDelete.imageView!.clipsToBounds = true
        keyDelete.imageView!.contentMode = .center
        accessory.addSubview(keyDelete)
        
        let keyHeader = UIButton()
        keyHeader.translatesAutoresizingMaskIntoConstraints = false
        keyHeader.setImage(#imageLiteral(resourceName: "header.pdf"), for:.normal)
        keyHeader.imageView!.clipsToBounds = true
        keyHeader.imageView!.contentMode = .center
        keyHeader.addTarget(self, action:#selector(header), for:.touchUpInside)
        accessory.addSubview(keyHeader)
        
        let keyBold = UIButton()
        keyBold.translatesAutoresizingMaskIntoConstraints = false
        keyBold.setImage(#imageLiteral(resourceName: "bold.pdf"), for:.normal)
        keyBold.imageView!.clipsToBounds = true
        keyBold.imageView!.contentMode = .center
        keyBold.addTarget(self, action:#selector(bold), for:.touchUpInside)
        accessory.addSubview(keyBold)
        
        let keyItalic = UIButton()
        keyItalic.translatesAutoresizingMaskIntoConstraints = false
        keyItalic.setImage(#imageLiteral(resourceName: "italic.pdf"), for:.normal)
        keyItalic.imageView!.clipsToBounds = true
        keyItalic.imageView!.contentMode = .center
        keyItalic.addTarget(self, action:#selector(italic), for:.touchUpInside)
        accessory.addSubview(keyItalic)
        
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        indicator.backgroundColor = .scottBlue
        text.addSubview(indicator)
        
        text.bottomAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
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
        
        keyHeader.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyHeader.leftAnchor.constraint(equalTo:keyList.rightAnchor).isActive = true
        keyHeader.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyHeader.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        keyBold.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyBold.leftAnchor.constraint(equalTo:keyHeader.rightAnchor).isActive = true
        keyBold.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyBold.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        keyItalic.topAnchor.constraint(equalTo:accessory.topAnchor).isActive = true
        keyItalic.leftAnchor.constraint(equalTo:keyBold.rightAnchor).isActive = true
        keyItalic.widthAnchor.constraint(equalTo:accessory.widthAnchor, multiplier:0.14).isActive = true
        keyItalic.heightAnchor.constraint(equalToConstant:54).isActive = true
        
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
            
            accessoryBottom = accessory.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            text.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            
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
    
    private func scrollToTop() {
        scrollTo(CGRect(x:0, y:0, width:1, height:1))
    }
    
    private func scrollTo(_ frame:CGRect) {
        (items.superview as! UIScrollView).scrollRectToVisible(frame, animated:true)
    }
    
    private func insert(_ string:String) {
        if !text.isFirstResponder {
            text.becomeFirstResponder()
        }
        text.insertText(string)
    }
    
    @objc private func list() {
        keyList.isSelected.toggle()
        if keyList.isSelected {
            text.resignFirstResponder()
            accessoryHeight.constant = min(view.frame.width, view.frame.height)
        } else {
            accessoryHeight.constant = 54
            text.becomeFirstResponder()
        }
        UIView.animate(withDuration:0.3, animations: {
            self.view.layoutIfNeeded()
        } ) { _ in
            self.text.setNeedsDisplay()
        }
    }
    
    @objc private func select(item:ItemView) {
        if presenter.selected !== item {
            presenter.selected = item
            text.text = item.note.content
            text.scrollRangeToVisible(NSRange())
            text.selectedRange = NSRange()
            scrollTo(item.frame)
        }
    }
    
    @objc private func new() {
        presenter.new()
        indicatorTop.constant = view.bounds.height
        scrollToTop()
        UIView.animate(withDuration:0.5, animations: {
            self.text.alpha = 0
            self.text.layoutIfNeeded()
        }) { _ in
            self.indicatorTop.constant = -10
            UIView.animate(withDuration:0.4) {
                self.text.alpha = 1
            }
        }
    }
    
    @objc private func share() {
        presenter.saveIfNeeded()
        present(PreviewView(presenter.selected.note), animated:true)
    }
    
    @objc private func remove() { present(DeleteView(presenter), animated:true) }
    @objc private func header() { insert("#") }
    @objc private func bold() { insert("*") }
    @objc private func italic() { insert("_") }
}
