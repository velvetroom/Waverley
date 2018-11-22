import Cocoa

class View:NSView, NSTextViewDelegate {
    private weak var text:NSTextView!
    
    func showList() {
        print("show list")
    }
    
    func hideList() {
        print("hide list")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeOutlets()
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
        
        scrollText.topAnchor.constraint(equalTo:topAnchor, constant:38).isActive = true
        scrollText.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        scrollText.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        scrollText.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
    }
}
