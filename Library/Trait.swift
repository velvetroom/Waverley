import Foundation

public struct Trait {
    enum Mode {
        case regular
        case bold
        case italic
        case boldItalic
    }
    let model:Mode
    let range:NSRange
}
