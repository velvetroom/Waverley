import Foundation

public class Markdown {
    private let options:[(Character, ((Markdown) -> (String, Trait.Mode) -> [Trait]))] = [
        ("*", bold), ("_", italic), ("#", header)]
    
    public init() { } 
    
    public func parse(_ string:String) -> [Trait] {
        return parsing(string, current:.regular)
    }
    
    private func parsing(_ string:String, current:Trait.Mode) -> [Trait] {
        if let detected = options.compactMap(
            { character, function -> (String.Index, ((Markdown) -> (String, Trait.Mode) -> [Trait]))? in
            guard let index = string.firstIndex(of:character) else { return nil }
            return (index, function)
        } ).sorted(by: { $0.0 < $1.0 } ).first?.1 {
            return detected(self)(string, current)
        }
        return build(string, current:current)
    }
    
    private func header(_ string:String, current:Trait.Mode) -> [Trait] {
        let begin = string.firstIndex(of:"#")!
        var addSize = 10.0
        var after = string.index(after:begin)
        if string[after] == "#" {
            addSize = 4
            after = string.index(after:after)
        }
        if string[after] == " " {
            after = string.index(after:after)
        }
        var result = parsing(String(string[..<begin]), current:current)
        if let end = string[after...].firstIndex(of:"\n") {
            result += [Trait(mode:.bold, string:String(string[after...end]), addSize:addSize)] +
                parsing(String(string[string.index(after:end)...]), current:current)
        } else {
            result += [Trait(
                mode:.bold, string:String(string[after...]), addSize:addSize)]
        }
        return result
    }

    private func bold(_ string:String, current:Trait.Mode) -> [Trait] {
        return compare(string, using:"*", current:current, result:current + .bold)
    }
    
    private func italic(_ string:String, current:Trait.Mode) -> [Trait] {
        return compare(string, using:"_", current:current, result:current + .italic)
    }
    
    private func compare(_ string:String, using:Character, current:Trait.Mode, result:Trait.Mode) -> [Trait] {
        let begin = string.firstIndex(of:using)!
        let end = string[string.index(after:begin)...].firstIndex(of:using)!
        return parsing(String(string[..<begin]), current:current) +
            parsing(String(string[string.index(after:begin)..<end]), current:result) +
            parsing(String(string[string.index(after:end)...]), current:current)
    }
    
    private func build(_ string:String, current:Trait.Mode) -> [Trait] {
        if string.isEmpty { return [] }
        return [Trait(mode:current, string:string, addSize:0)]
    }
}
