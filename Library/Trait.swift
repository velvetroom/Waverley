import Foundation

public struct Trait {
    public enum Mode {
        case regular
        case bold
        case italic
        case boldItalic
    }
    public let model:Mode
    public let range:NSRange
}
