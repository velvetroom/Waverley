import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return parsing(string, current:.regular)
    }
    
    private func parsing(_ string:String, current:Trait.Mode) -> [Trait] {
        if let begin = string.firstIndex(of:"*") {
            if let end = string[string.index(after:begin)...].firstIndex(of:"*") {
                return parsing(String(string[..<begin]), current:current) +
                    parsing(String(string[string.index(after:begin)..<end]), current:current + .bold) +
                    parsing(String(string[string.index(after:end)...]), current:current)
            }
        }
        return build(string, current:current)
    }
    
    private func build(_ string:String, current:Trait.Mode) -> [Trait] {
        if string.isEmpty { return [] }
        switch current {
        case .regular: return [Trait(mode:.regular, string:string, addSize:0)]
        case .bold: return [Trait(mode:.bold, string:string, addSize:0)]
        default: return []
        }
    }
}
