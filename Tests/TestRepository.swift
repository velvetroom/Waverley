import XCTest
@testable import Mobile

class TestRepository:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        Factory.storage = MockStorage()
    }
    
    override func tearDown() {
        Factory.storage = nil
    }
    
    func testNewNote() {
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertFalse(repository.notes.values.first!.id.isEmpty)
        XCTAssertEqual(repository.notes.values.first!.id, repository.notes.keys.first!)
        XCTAssertEqual(repository.notes.values.first!.id, repository.account.notes.first!)
    }
}
