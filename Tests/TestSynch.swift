import XCTest
@testable import Desktop

class TestSynch:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    private var synch:MockSynch!
    
    override func setUp() {
        repository = Repository()
        storage = MockStorage()
        synch = MockSynch()
        Factory.storage = storage
        Factory.synch = synch
        repository.select = { _ in }
    }
    
    override func tearDown() {
        Factory.storage = MockStorage()
        Factory.synch = MockSynch()
    }
}
