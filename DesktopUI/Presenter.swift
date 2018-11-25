import Foundation
import Desktop

class Presenter {
    weak var selected:ItemView! {
        willSet {
            if let previous = selected {
                previous.selected = false
            }
        }
        didSet {
            selected.selected = true
        }
    }
    var notes:(([Note]) -> Void)!
    var select:((Note) -> Void)!
    private let repository = Factory.makeRepository()
    
    init() {
        Factory.storage = Storage()
    }
    
    func load() {
        DispatchQueue.global(qos:.background).async {
            self.repository.load()
            let note = self.repository.editing()
            DispatchQueue.main.async {
                self.updateNotes()
                self.select(note)
            }
        }
    }
    
    private func updateNotes() {
        notes(repository.notes.values.sorted(by: { $0.created > $1.created }))
    }
}
