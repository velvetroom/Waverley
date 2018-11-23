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
            DispatchQueue.main.async {
                self.update(Array(self.repository.notes.values))
            }
        }
    }
}
