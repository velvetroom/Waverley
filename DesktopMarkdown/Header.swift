import AppKit

class Header {
    private let font:NSFont
    private let items = [HeaderItem(match:"### ", increment:1), HeaderItem(match:"## ", increment:7),
                         HeaderItem(match:"# ", increment:15)]
    
    init(font:NSFont) {
        self.font = font
    }
    
    func parse(string:String, nonHeader:((String) -> NSAttributedString)) -> NSAttributedString {
        return parse(string:string, items:items, non:nonHeader)
    }
    
    private func parse(string:String, items:[HeaderItem], non:((String) -> NSAttributedString)) -> NSAttributedString {
        if items.isEmpty {
            return non(string)
        }
        return header(string:string, items:items, non:non)
    }
    
    private func header(string:String, items:[HeaderItem], non:((String) -> NSAttributedString)) -> NSAttributedString {
        var items = items
        let item = items.removeFirst()
        let mutable = NSMutableAttributedString()
        var components = string.components(separatedBy:item.match)
        let first = components.removeFirst()
        if !first.isEmpty {
            mutable.append(parse(string:first, items:items, non:non))
        }
        return components.reduce(into:mutable) { mutable, component in
            if let index = component.index(of:"\n") {
                mutable.append(head(item:item, string:String(component.prefix(upTo:index))))
                mutable.append(parse(string:String(component.suffix(from:index)), items:items, non:non))
            } else {
                mutable.append(head(item:item, string:component))
            }
        }
    }
    
    private func head(item:HeaderItem, string:String) -> NSAttributedString {
        return NSAttributedString(string:string, attributes:[.font:NSFont.systemFont(ofSize:
            font.pointSize + item.increment, weight:.bold)])
    }
}
