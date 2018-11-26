import AppKit

struct StackItem {
    let interpreter:Interpreter
    let font:NSFont
    
    init(interpreter:Interpreter, font:NSFont) {
        self.interpreter = interpreter
        self.font = font
    }
}
