import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return [Trait(mode:.regular, string:"hello world", addSize:0)]
    }
}
