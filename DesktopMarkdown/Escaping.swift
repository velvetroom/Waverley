import AppKit

class Escaping {
    private let font:NSFont
    
    init(font:NSFont) {
        self.font = font
    }
    
    func parse(string:String, nonScaped:((String) -> NSAttributedString)) -> NSAttributedString {
        var components = string.components(separatedBy:"```")
        let mutable = NSMutableAttributedString()
        for index in 0 ..< components.count {
            if index % 2 == 0 {
                mutable.append(nonScaped(components[index]))
            } else {
                mutable.append(NSAttributedString(string:components[index], attributes:[.font:font]))
            }
        }
        return mutable
    }
}
