import Foundation
import Desktop

class Presenter {
    var update:(([Note]) -> Void)!
    private let repository = Factory.makeRepository()
    
    init() {
        Factory.storage = Storage()
    }
    
    func load() {
        DispatchQueue.global(qos:.background).async {
            self.repository.load()
            DispatchQueue.main.async { self.updateNotes() }
        }
    }
    
    private func updateNotes() {
        update(repository.notes.values.sorted(by: { $0.created > $1.created }))
    }
}
