import Foundation

public struct Trait {
    public enum Mode {
        case regular
        case bold
        case italic
        case boldItalic
    }
    public let mode:Mode
    public let range:NSRange
    public let addSize:Double
}
