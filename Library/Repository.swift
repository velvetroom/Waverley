import Foundation

public class Repository {
    public var update:(([Note]) -> Void)!
    public var select:((Note) -> Void)!
    var storage:Storage = Storer()
    var synch:Synch = Syncher()
    var notes = [Note]()
    private(set) var account = Account()
    
    public init() { }
    
    public func load() {
        if let account = try? storage.account() {
            self.account = account
        }
        loadNotes()
        newNote()
    }
    
    public func startSynch() {
        synch.updates = { items in
            items.forEach { item in
                if let current = self.notes.first(where: { $0.id == item.key } ) {
                    if current.synchstamp < item.value {
                        self.synch.load(item.key)
                    }
                } else {
                    self.synch.load(item.key)
                }
            }
        }
        synch.loaded = { note in
            self.remove(note.id)
            self.add(note)
            self.update(self.notes)
            self.select(note)
        }
        synch.start()
    }
    
    public func update(_ note:Note, content:String) {
        note.content = content
        note.synchstamp = Date().timeIntervalSince1970
        if !content.isEmpty {
            saveRemote()
        }
        save(note)
    }
    
    public func newNote() {
        let note = createNote()
        update(notes)
        select(note)
    }
    
    public func delete(_ note:Note) {
        remove(note.id)
        saveLocally()
        saveRemote()
        storage.delete(note)
        newNote()
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
    
    public func rate() -> Bool {
        var rating = false
        account.created += 1
        if (account.created % 4) == 0 {
            if let last = account.rates.last,
                let months = Calendar.current.dateComponents([.month], from:last, to:Date()).month {
                rating = months < -1
            } else {
                rating = true
            }
        }
        if rating {
            account.rates.append(Date())
        }
        saveLocally()
        return rating
    }
    
    func createNote() -> Note {
        if notes.first?.content.isEmpty != true {
            let note = Note()
            note.id = UUID().uuidString
            note.created = Date().timeIntervalSince1970
            note.synchstamp = note.created
            add(note)
        }
        return notes.first!
    }
    
    private func loadNotes() {
        var notes = [Note]()
        account.notes.forEach { id in
            notes.append(storage.note(id))
        }
        self.notes = notes
        sort()
    }
    
    private func add(_ note:Note) {
        account.notes.append(note.id)
        notes.append(note)
        sort()
        saveLocally()
        save(note)
    }
    
    private func remove(_ id:String) {
        notes.removeAll { $0.id == id }
        account.notes.removeAll { $0 == id }
    }
    
    private func sort() {
        notes.sort { $0.created > $1.created }
    }
    
    private func saveLocally() {
        storage.save(account)
    }
    
    private func saveRemote() {
        synch.save(notes.reduce(into:[:], { result, note in
            if !note.content.isEmpty {
                result[note.id] = note.synchstamp
            }
        } ))
    }
    
    private func save(_ note:Note) {
        storage.save(note)
        if !note.content.isEmpty {
            synch.save(note)
        }
    }
}
