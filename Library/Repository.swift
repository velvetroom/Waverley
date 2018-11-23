import Foundation

public class Repository {
    public private(set) var notes = [String:Note]()
    private(set) var account = Account()
    
    public func load() {
        do {
            account = try Factory.storage.account()
        } catch {
            Factory.storage.save(account)
        }
        loadNotes()
    }
    
    public func newNote() {
        let note = Note()
        note.id = UUID().uuidString
        account.notes.append(note.id)
        notes[note.id] = note
        Factory.storage.save(account)
        Factory.storage.save(note)
    }
    
    private func loadNotes() {
        account.notes.forEach { id in
            notes[id] = Factory.storage.note(id)
        }
    }
}
