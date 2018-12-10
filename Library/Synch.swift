import Foundation

protocol Synch {
    var updates:(([String:TimeInterval]) -> Void)! { get set }
    var loaded:((Note) -> Void)! { get set }
    
    func start()
    func load(_ id:String)
    func save(_ account:[String:TimeInterval])
    func save(_ note:Note)
}
