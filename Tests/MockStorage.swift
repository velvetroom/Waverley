import Foundation
@testable import Mobile

class MockStorage:Storage {
    var onAccount:(() -> Void)?
    var onNote:((String) -> Void)?
    var onSaveAccount:(() -> Void)?
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
    
    func save(account:Account) {
        onSaveAccount?()
    }
}
