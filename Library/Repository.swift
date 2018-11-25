import Foundation

public class Repository {
    public private(set) var notes = [String:Note]()
    private(set) var account = Account()
    private var newest:Note? { return notes.values.sorted(by: { $0.created > $1.created } ).first }
    
    public func load() {
        do {
            account = try Factory.storage.account()
        } catch {
            Factory.storage.save(account)
        }
        loadNotes()
    }
    
    public func editing() -> Note {
        if newest?.content.isEmpty == true {
            return newest!
        } else {
            newNote()
            return newest!
        }
    }
    
    public func newNote() {
        if newest?.content.isEmpty != true {
            let note = Note()
            note.id = UUID().uuidString
            note.created = Date().timeIntervalSince1970
            account.notes.append(note.id)
            notes[note.id] = note
            Factory.storage.save(account)
            Factory.storage.save(note)
        }
    }
    
    public func update(_ note:Note, content:String) {
        note.content = content
        Factory.storage.save(note)
    }
    
    private func loadNotes() {
        account.notes.forEach { id in
            notes[id] = Factory.storage.note(id)
        }
    }
}
