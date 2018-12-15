import Foundation

class Storer:Storage {
    private static let url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0]
    private static let account = url.appendingPathComponent("Account.waverley")
    
    class func note(_ id:String) -> URL { return url.appendingPathComponent(id + ".waverley") }
    
    func account() throws -> Account {
        avoidBackup()
        return try JSONDecoder().decode(Account.self, from:try Data(contentsOf:Storer.account))
    }
    
    func note(_ id:String) -> Note {
        return try! JSONDecoder().decode(Note.self, from:try Data(contentsOf:Storer.note(id)))
    }
    
    func save(_ account:Account) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(account)).write(to:Storer.account)
        }
    }
    
    func save(_ note:Note) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(note)).write(to:Storer.note(note.id))
        }
    }
    
    func delete(_ note:Note) {
        DispatchQueue.global(qos:.background).async {
            if FileManager.default.fileExists(atPath:Storer.note(note.id).path) {
                try! FileManager.default.removeItem(at:Storer.note(note.id))
            }
        }
    }
    
    private func avoidBackup() {
        var url = Storer.url
        var resources = URLResourceValues()
        resources.isExcludedFromBackup = true
        try! url.setResourceValues(resources)
    }
}
