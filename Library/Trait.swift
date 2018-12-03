import Foundation

public struct Trait {
    public enum Mode {
        case regular
        case bold
        case italic
        case boldItalic
        
        static func +(left:Mode, right:Mode) -> Mode {
            switch left {
            case .regular:
                return right
            case .italic:
                if right == .bold {
                    return .boldItalic
                }
            case .bold:
                if right == .italic {
                    return .boldItalic
                }
            default: break
            }
            return left
        }
    }
    public let mode:Mode
    public let string:String
    public let addSize:Double
}
