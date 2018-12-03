import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return parsing(string, current:.regular)
    }
    
    private func parsing(_ string:String, current:Trait.Mode) -> [Trait] {
        return [Trait(mode:.regular, string:string, addSize:0)]
    }
}
