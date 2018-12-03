import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return parsing(string, current:.regular)
    }
    
    private func parsing(_ string:String, current:Trait.Mode) -> [Trait] {
        let bold = compare(string, using:"*", current:current, result:current + .bold)
        let italic = compare(string, using:"_", current:current, result:current + .italic)
        if !bold.isEmpty && !italic.isEmpty {
            if bold.count > italic.count {
                return italic
            }
            return bold
        } else if !bold.isEmpty {
            return bold
        } else if !italic.isEmpty {
            return italic
        }
        return build(string, current:current)
    }
    
    private func compare(_ string:String, using:Character, current:Trait.Mode, result:Trait.Mode) -> [Trait] {
        if let begin = string.firstIndex(of:using) {
            if let end = string[string.index(after:begin)...].firstIndex(of:using) {
                return parsing(String(string[..<begin]), current:current) +
                    parsing(String(string[string.index(after:begin)..<end]), current:result) +
                    parsing(String(string[string.index(after:end)...]), current:current)
            }
        }
        return []
    }
    
    private func build(_ string:String, current:Trait.Mode) -> [Trait] {
        if string.isEmpty { return [] }
        return [Trait(mode:current, string:string, addSize:0)]
    }
}
