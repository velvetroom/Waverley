import Foundation

public class Repository {
    public private(set) var notes = [String:Note]()
    private(set) var account = Account()
    
    public func load() {
        do {
            account = try Factory.storage.account()
        } catch {
            Factory.storage.save(account:account)
        }
        loadNotes()
    }
    
    private func loadNotes() {
        account.notes.forEach { id in
            notes[id] = Factory.storage.note(id)
        }
    }
}
