import AppKit

class ItalicsInterpreter:Interpreter {
    let match = ["*", "_"]
    
    func update(font:NSFont) -> NSFont {
        return NSFont(descriptor:NSFontDescriptor(name:font.familyName!, size:font.pointSize).withSymbolicTraits(
            .italic), size:font.pointSize)!
    }
}
