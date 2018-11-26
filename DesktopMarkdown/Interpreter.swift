import AppKit

protocol Interpreter:AnyObject {
    var match:[String] { get }
    
    func update(font:NSFont) -> NSFont
}
