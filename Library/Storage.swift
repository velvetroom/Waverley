import Foundation

protocol Storage {
    func account() throws -> Account
    func note(_ id:String) -> Note
    func save(_ account:Account)
    func save(_ note:Note)
    func delete(_ note:Note)
}
