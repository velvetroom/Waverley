import Foundation

public class Repository {
    public var update:(([Note]) -> Void)!
    public var select:((Note) -> Void)!
    var notes = [Note]()
    var editing:Note {
        if notes.first?.content.isEmpty != true {
            newNote()
        }
        return notes.first!
    }
    
    private(set) var account = Account()
    
    public func load() {
        if let account = try? Factory.storage.account() {
            self.account = account
        }
        loadNotes()
        let editing = self.editing
        update(notes)
        select(editing)
    }
    
    public func newNote() {
        if notes.first?.content.isEmpty != true {
            let note = Note()
            note.id = UUID().uuidString
            note.created = Date().timeIntervalSince1970
            account.notes.append(note.id)
            notes.insert(note, at:0)
            Factory.storage.save(account)
            Factory.storage.save(note)
        }
    }
    
    public func update(_ note:Note, content:String) {
        note.content = content
        Factory.storage.save(note)
    }
    
    public func delete(_ note:Note) {
        notes.remove(at:notes.firstIndex { $0 === note }!)
        account.notes.removeAll { $0 == note.id }
        Factory.storage.save(account)
        Factory.storage.delete(note)
    }
    
    public func next(_ note:Note) {
        let index = notes.firstIndex { $0 === note }!
        if index < notes.count - 1 {
            select(notes[index + 1])
        } else {
            select(notes[0])
        }
    }
    
    public func previous(_ note:Note) {
        let index = notes.firstIndex { $0 === note }!
        if index > 0 {
            select(notes[index - 1])
        } else {
            select(notes.last!)
        }
    }
    
    private func loadNotes() {
        var notes = [Note]()
        account.notes.forEach { id in
            notes.append(Factory.storage.note(id))
        }
        self.notes = notes.sorted { $0.created > $1.created }
    }
}
