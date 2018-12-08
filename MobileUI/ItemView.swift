import UIKit
import Mobile

class ItemView:UIControl {
    private(set) weak var note:Note!
    private weak var label:UILabel!
    private weak var selector:UIView!
    override var isSelected: Bool { didSet { update() } }
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:54) }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        label.textColor = .white
        label.font = .systemFont(ofSize:14, weight:.ultraLight)
        addSubview(label)
        self.label = label
        
        let selector = UIView()
        selector.isUserInteractionEnabled = false
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.backgroundColor = .scottBlue
        selector.layer.cornerRadius = 2
        addSubview(selector)
        self.selector = selector
        
        label.topAnchor.constraint(equalTo:topAnchor, constant:7).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:34).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-34).isActive = true
        
        selector.topAnchor.constraint(equalTo:topAnchor, constant:7).isActive = true
        selector.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-7).isActive = true
        selector.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        selector.widthAnchor.constraint(equalToConstant:4).isActive = true
        
        update(note.content)
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ content:String) {
        label.text = String(content.prefix(200))
    }
    
    private func update() {
        if isSelected {
            label.alpha = 0.8
            selector.alpha = 1
        } else {
            label.alpha = 0.35
            selector.alpha = 0
        }
    }
}
