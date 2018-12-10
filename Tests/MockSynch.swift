import Foundation
@testable import Desktop

class MockSynch:Synch {
    var updates:(([String:TimeInterval]) -> Void)!
    var loaded:((Note) -> Void)!
    var onLoad:((String) -> Void)?
    var onSaveAccount:(([String:TimeInterval]) -> Void)?
    var onSaveNote:((Note) -> Void)?
    var items:[String:Double]?
    var note:Note?
    
    func start() {
        if let items = self.items {
            updates(items)
        }
    }
    
    func load(_ id:String) {
        onLoad?(id)
        if let note = self.note {
            loaded(note)
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        onSaveAccount?(account)
    }
    
    func save(_ note:Note) {
        onSaveNote?(note)
    }
}
