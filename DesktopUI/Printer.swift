import AppKit
import Desktop

class Printer {
    class func print(_ string:String, size:CGFloat) -> NSAttributedString {
        let result = NSMutableAttributedString()
        Markdown().parse(string).forEach { trait in
            var font:NSFont
            let size = size + CGFloat(trait.addSize)
            switch trait.mode {
            case .bold: font = .printBold(size)
            case .boldItalic: font = .printBoldItalic(size)
            case .italic: font = .printLightItalic(size)
            default: font = .printLight(size)
            }
            result.append(NSAttributedString(string:trait.string, attributes:[.font:font]))
        }
        return result
    }
}
