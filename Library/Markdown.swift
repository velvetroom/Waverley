import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return parsing(string, current:.regular)
    }
    
    private func parsing(_ string:String, current:Trait.Mode) -> [Trait] {
        if let bold = compare(string, using:"*", current:current, result:current + .bold) {
            return bold
        } else if let italic = compare(string, using:"_", current:current, result:current + .italic) {
            return italic
        }
        return build(string, current:current)
    }
    
    private func compare(_ string:String, using:Character, current:Trait.Mode, result:Trait.Mode) -> [Trait]? {
        if let begin = string.firstIndex(of:using) {
            if let end = string[string.index(after:begin)...].firstIndex(of:using) {
                return parsing(String(string[..<begin]), current:current) +
                    parsing(String(string[string.index(after:begin)..<end]), current:result) +
                    parsing(String(string[string.index(after:end)...]), current:current)
            }
        }
        return nil
    }
    
    private func build(_ string:String, current:Trait.Mode) -> [Trait] {
        if string.isEmpty { return [] }
        switch current {
        case .regular: return [Trait(mode:.regular, string:string, addSize:0)]
        case .bold: return [Trait(mode:.bold, string:string, addSize:0)]
        case .italic: return [Trait(mode:.italic, string:string, addSize:0)]
        default: return []
        }
    }
}
