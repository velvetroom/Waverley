import XCTest
@testable import Mobile

class TestStorage:XCTestCase {
    private var repository:Repository!

    override func setUp() {
        repository = Factory.makeRepository()
        Factory.storage = MockStorage()
    }
}
