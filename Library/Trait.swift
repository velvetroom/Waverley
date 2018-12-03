import Foundation

public struct Trait {
    public enum Mode {
        case regular
        case bold
        case italic
        case boldItalic
        
        static func +(left:Mode, right:Mode) -> Mode {
            switch left {
            case .regular: return right
            default: return right
            }
        }
    }
    public let mode:Mode
    public let string:String
    public let addSize:Double
}
