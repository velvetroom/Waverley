import Foundation
@testable import Desktop

class MockStorage:Storage {
    var onAccount:(() -> Void)?
    var onNote:((String) -> Void)?
    var onSaveAccount:(() -> Void)?
    var onSaveNote:(() -> Void)?
    var onDeleteNote:(() -> Void)?
    var returnAccount = Account()
    var returnNote = Note()
    var error:Error?
    
    required init() { }
    
    func account() throws -> Account {
        onAccount?()
        if let error = self.error {
            throw error
        } else {
            return returnAccount
        }
    }
    
    func note(_ id:String) -> Note {
        onNote?(id)
        return returnNote
    }
    
    func save(_ account:Account) {
        onSaveAccount?()
    }
    
    func save(_ note:Note) {
        onSaveNote?()
    }
    
    func delete(_ note:Note) {
        onDeleteNote?()
    }
}
