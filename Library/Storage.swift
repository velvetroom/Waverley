import Foundation

public protocol Storage {
    init()
    func account() throws -> Account
    func note(_ id:String) -> Note
    func save(_ account:Account)
    func save(_ note:Note)
}

public extension Storage {
    private var url:URL { return FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0] }
    
    func account() throws -> Account {
        avoidBackup()
        return try JSONDecoder().decode(Account.self, from:try
            Data(contentsOf:url.appendingPathComponent("Account.waverley")))
    }
    
    func note(_ id:String) -> Note {
        return try! JSONDecoder().decode(Note.self, from:try
            Data(contentsOf:url.appendingPathComponent(id + ".waverley")))
    }
    
    func save(_ account:Account) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(account)).write(to:self.url.appendingPathComponent("Account.waverley"))
        }
    }
    
    func save(_ note:Note) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(note)).write(to:self.url.appendingPathComponent(note.id + ".waverley"))
        }
    }
    
    private func avoidBackup() {
        var url = self.url
        var resources = URLResourceValues()
        resources.isExcludedFromBackup = true
        try! url.setResourceValues(resources)
    }
}
