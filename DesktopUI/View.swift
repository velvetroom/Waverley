import AppKit
import Desktop

class View:NSView, NSTextViewDelegate {
    let presenter = Presenter()
    private weak var scroll:NSScrollView!
    private weak var text:NSTextView!
    private weak var list:NSScrollView!
    private weak var listWidth:NSLayoutConstraint!
    private weak var indicatorTop:NSLayoutConstraint!
    
    func new() {
        indicatorTop.constant = text.bounds.height + 11
        NSAnimationContext.runAnimationGroup( { context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            self.text.alphaValue = 0
            self.text.layoutSubtreeIfNeeded()
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
        listWidth.constant = 120
        animateConstraints()
    }
    
    func hideList() {
        listWidth.constant = 0
        animateConstraints()
    }
    
    func textDidChange(_:Notification) {
        presenter.update(text.string)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeOutlets()
        presenter.notes = { self.update($0) }
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
        let separator = NSView(frame:.zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.scotBlue.cgColor
        addSubview(separator)
        
        let scroll = NSScrollView(frame:.zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        self.scroll = scroll
        
        let text = NSTextView(frame:.zero)
        text.isVerticallyResizable = true
        text.isContinuousSpellCheckingEnabled = true
        text.font = NSFont(name:"SourceCodeRoman-Light", size:18)
        text.delegate = self
        text.allowsUndo = true
        text.drawsBackground = false
        scroll.documentView = text
        self.text = text
        
        let list = NSScrollView(frame:.zero)
        list.drawsBackground = false
        list.translatesAutoresizingMaskIntoConstraints = false
        list.hasVerticalScroller = true
        list.documentView = DocumentView()
        (list.documentView! as! DocumentView).autoLayout()
        addSubview(list)
        self.list = list
        
        let indicatorBorder = NSView(frame:.zero)
        indicatorBorder.translatesAutoresizingMaskIntoConstraints = false
        indicatorBorder.wantsLayer = true
        indicatorBorder.layer!.backgroundColor = NSColor.scotBlue.cgColor
        text.addSubview(indicatorBorder)
        
        let indicator = NSView(frame:.zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.wantsLayer = true
        indicator.layer!.backgroundColor = NSColor.scotBlue.withAlphaComponent(0.5).cgColor
        text.addSubview(indicator)
        
        scroll.topAnchor.constraint(equalTo:topAnchor, constant:38).isActive = true
        scroll.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo:scroll.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        listWidth = list.widthAnchor.constraint(equalToConstant:0)
        listWidth.isActive = true
        
        separator.topAnchor.constraint(equalTo:list.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo:list.bottomAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo:text.leftAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant:1).isActive = true
        
        indicatorBorder.heightAnchor.constraint(equalToConstant:1).isActive = true
        indicatorBorder.leftAnchor.constraint(equalTo:text.leftAnchor).isActive = true
        indicatorBorder.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        indicatorTop = indicatorBorder.topAnchor.constraint(equalTo:text.topAnchor, constant:-1)
        indicatorTop.isActive = true
        
        indicator.heightAnchor.constraint(equalToConstant:10).isActive = true
        indicator.leftAnchor.constraint(equalTo:text.leftAnchor).isActive = true
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
        let inset:CGFloat = max((scroll.frame.width - 700) / 2, 20)
        text.textContainerInset = NSSize(width:inset, height:50)
        text.setFrameSize(NSSize(width:scroll.frame.width, height:text.frame.height))
        text.textContainer!.size = NSSize(width:scroll.frame.width - (inset + inset), height:.greatestFiniteMagnitude)
    }
    
    @objc private func select(item:ItemView) {
        presenter.selected = item
        text.string = item.note.content
    }
}
