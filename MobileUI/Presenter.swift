import Foundation
import Mobile

class Presenter {
    weak var selected:ItemView! {
        willSet {
            if let previous = selected {
                previous.selected = false
            }
        }
        didSet {
            selected.selected = true
            saveIfNeeded()
        }
    }
    
    var notes:(([Note]) -> Void)!
    var select:((Note) -> Void)!
    private weak var timer:Timer?
    private var notesSorted:[Note] { return repository.notes.values.sorted(by: { $0.created > $1.created }) }
    private let repository = Factory.makeRepository()
    
    init() {
        Factory.storage = Storage()
    }
}
