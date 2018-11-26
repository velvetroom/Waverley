import AppKit

class BoldInterpreter:Interpreter {
    let match = ["**", "__"]
    
    func update(font:NSFont) -> NSFont {
        if font.fontDescriptor.symbolicTraits.contains(NSFontDescriptor.SymbolicTraits.italic) {
            return NSFont(descriptor:NSFont.systemFont(ofSize:font.pointSize, weight:.bold).fontDescriptor.withSymbolicTraits(
                [.italic, .bold]), size:font.pointSize)!
        }
        return .systemFont(ofSize:font.pointSize, weight:.bold)
    }
}
