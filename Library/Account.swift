import Foundation

struct Account:Codable {
    var notes = [String]()
    var rates = [Date]()
    var created = 0
}
