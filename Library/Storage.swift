import Foundation

public protocol Storage {
    init()
    func account() throws -> Account
    func note(_ id:String) -> Note
    func save(_ account:Account)
    func save(_ note:Note)
}
