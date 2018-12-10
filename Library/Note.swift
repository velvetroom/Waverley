import Foundation

public class Note:Codable {
    public internal(set) var id = String()
    public internal(set) var created = 0.0
    public internal(set) var synchstamp = 0.0
    public internal(set) var content = String()
}
