import Foundation

public class Factory {
    public static var storage:Storage!
    private static let repository = Repository()
    
    public class func makeRepository() -> Repository {
        return repository
    }
}
