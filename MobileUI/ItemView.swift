import UIKit
import Mobile

class ItemView:UIControl {
    private(set) weak var note:Note!
    private weak var label:UILabel!
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:54) }
    override var isSelected:Bool { didSet {
        if isSelected {
            backgroundColor = UIColor(white:1, alpha:0.1)
        } else {
            backgroundColor = .clear
        }
    } }
    
    init(_ note:Note) {
        self.note = note
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        label.textColor = UIColor(white:1, alpha:0.7)
        label.font = .systemFont(ofSize:12, weight:.ultraLight)
        addSubview(label)
        self.label = label
        
        label.topAnchor.constraint(equalTo:topAnchor, constant:12).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        
        update(note.content)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ content:String) {
        label.text = String(content.prefix(200))
    }
}
