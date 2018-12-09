import Foundation

public class Factory {
    static var storage:Storage = Storer()
    private static let repository = Repository()
    
    public class func makeRepository() -> Repository {
        return repository
    }
}
