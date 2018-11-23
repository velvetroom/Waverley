import Foundation

public protocol Storage {
    init()
    func account() throws -> Account
    func note(_ id:String) -> Note
    func save(account:Account)
}
