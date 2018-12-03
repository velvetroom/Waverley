import Foundation

public class Markdown {
    public func parse(_ string:String) -> [Trait] {
        return [Trait(mode:.regular, range:NSMakeRange(0, 10), addSize:0)]
    }
}
