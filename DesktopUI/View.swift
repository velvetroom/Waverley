import AppKit
import Desktop

class View:NSView, NSTextViewDelegate {
    let presenter = Presenter()
    private weak var text:TextView!
    private weak var scroll:NSScrollView!
    private weak var list:NSScrollView!
    private weak var listWidth:NSLayoutConstraint!
    private weak var indicatorTop:NSLayoutConstraint!
    
    func new() {
        indicatorTop.constant = bounds.height + 11
        NSAnimationContext.runAnimationGroup( { context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            self.text.alphaValue = 0
            self.layoutSubtreeIfNeeded()
        }) {
            self.indicatorTop.constant = -1
            self.presenter.new()
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                self.text.alphaValue = 1
            }
        }
    }
    
    func showList() {
        listWidth.constant = 250
        animateConstraints()
    }
    
    func hideList() {
        listWidth.constant = 0
        animateConstraints()
    }
    
    func textDidChange(_:Notification) {
        presenter.update(text.string)
        updateTextHeight()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeOutlets()
        presenter.update = { self.update($0) }
        presenter.select = { self.select($0) }
        presenter.load()
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        updateContainer()
    }
    
    override func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
        DispatchQueue.main.async {
            self.updateContainer()
        }
    }
    
    private func makeOutlets() {
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.findBarPosition = .belowContent
        addSubview(scroll)
        self.scroll = scroll
        
        let text = TextView()
        text.delegate = self
        scroll.documentView = text
        self.text = text
        
        let list = NSScrollView()
        list.drawsBackground = false
        list.translatesAutoresizingMaskIntoConstraints = false
        list.hasVerticalScroller = true
        list.verticalScroller!.controlSize = .mini
        list.documentView = DocumentView()
        (list.documentView! as! DocumentView).autoLayout()
        addSubview(list)
        self.list = list
        
        let indicatorBorder = NSView()
        indicatorBorder.translatesAutoresizingMaskIntoConstraints = false
        indicatorBorder.wantsLayer = true
        indicatorBorder.layer!.backgroundColor = NSColor.scottBlue.cgColor
        addSubview(indicatorBorder)
        
        let indicator = NSView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.wantsLayer = true
        indicator.layer!.backgroundColor = NSColor.scottBlue.withAlphaComponent(0.3).cgColor
        addSubview(indicator)
        
        scroll.topAnchor.constraint(equalTo:topAnchor, constant:38).isActive = true
        scroll.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo:scroll.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        listWidth = list.widthAnchor.constraint(equalToConstant:0)
        listWidth.isActive = true
        
        indicatorBorder.heightAnchor.constraint(equalToConstant:1).isActive = true
        indicatorBorder.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        indicatorBorder.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        indicatorTop = indicatorBorder.topAnchor.constraint(equalTo:topAnchor, constant:-1)
        indicatorTop.isActive = true
        
        indicator.heightAnchor.constraint(equalToConstant:10).isActive = true
        indicator.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        indicator.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo:indicatorBorder.topAnchor).isActive = true
    }
    
    private func update(_ notes:[Note]) {
        list.documentView!.subviews.forEach { $0.removeFromSuperview() }
        var top = list.documentView!.topAnchor
        notes.forEach { note in
            let item = ItemView(note)
            item.target = self
            item.action = #selector(select(item:))
            list.documentView!.addSubview(item)
            
            item.topAnchor.constraint(equalTo:top).isActive = true
            item.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
            top = item.bottomAnchor
        }
        list.documentView!.bottomAnchor.constraint(equalTo:top).isActive = true
    }
    
    private func select(_ note:Note) {
        let item = list.documentView!.subviews.first { ($0 as! ItemView).note === note } as! ItemView
        select(item:item)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            self.list.contentView.scrollToVisible(item.frame)
        }
    }
    
    private func animateConstraints() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.33
            context.allowsImplicitAnimation = true
            self.layoutSubtreeIfNeeded()
        }
    }
    
    private func updateContainer() {
        text.textContainerInset.width = max((scroll.frame.width - 700) / 2, 20)
        text.textContainer!.size.width = scroll.frame.width - (text.textContainerInset.width * 2)
        text.frame.size.width = scroll.frame.width
        updateTextHeight()
    }
    
    private func updateTextHeight() {
        text.layoutManager!.ensureLayout(for:text.textContainer!)
        text.frame.size.height = text.layoutManager!.usedRect(for:text.textContainer!).height + 100
    }
    
    @objc private func select(item:ItemView) {
        presenter.selected = item
        text.string = item.note.content
        updateTextHeight()
        text.scrollRangeToVisible(NSRange())
        text.setSelectedRange(NSRange())
    }
}
