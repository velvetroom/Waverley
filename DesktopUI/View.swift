import Cocoa
import Desktop

class View:NSView, NSTextViewDelegate {
    private weak var text:NSTextView!
    private weak var list:NSScrollView!
    private weak var listWidth:NSLayoutConstraint!
    private let presenter = Presenter()
    
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
    
    private func makeOutlets() {
        let scrollText = NSScrollView(frame:.zero)
        scrollText.translatesAutoresizingMaskIntoConstraints = false
        scrollText.hasVerticalScroller = true
        scrollText.verticalScroller!.controlSize = .mini
    
        scrollText.drawsBackground = false
        addSubview(scrollText)
        
        let text = NSTextView(frame:.zero)
        text.textContainerInset = NSSize(width:10, height:10)
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = true
        text.isContinuousSpellCheckingEnabled = true
        text.font = .systemFont(ofSize:16, weight:.ultraLight)
        text.delegate = self
        text.allowsUndo = true
        text.drawsBackground = false
        scrollText.documentView = text
        self.text = text
        
        let blur = NSVisualEffectView(frame:.zero)
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        
        let list = NSScrollView(frame:.zero)
        list.drawsBackground = false
        list.translatesAutoresizingMaskIntoConstraints = false
        list.hasVerticalScroller = true
        list.documentView = DocumentView()
        (list.documentView! as! DocumentView).autoLayout()
        addSubview(list)
        self.list = list
        
        scrollText.topAnchor.constraint(equalTo:topAnchor, constant:38).isActive = true
        scrollText.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        scrollText.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        scrollText.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        blur.topAnchor.constraint(equalTo:list.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:list.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo:scrollText.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        listWidth = list.widthAnchor.constraint(equalToConstant:0)
        listWidth.isActive = true
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
        select(item:list.documentView!.subviews.first { ($0 as! ItemView).note === note } as! ItemView)
    }
    
    private func animateConstraints() {
        NSAnimationContext.runAnimationGroup { [weak self] context in
            context.duration = 0.33
            context.allowsImplicitAnimation = true
            self?.layoutSubtreeIfNeeded()
        }
    }
    
    @objc private func select(item:ItemView) {
        presenter.selected = item
        text.string = item.note.content
    }
}
