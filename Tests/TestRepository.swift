import XCTest
@testable import Desktop

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
        let created = Date().timeIntervalSince1970
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertFalse(repository.notes.values.first!.id.isEmpty)
        XCTAssertGreaterThanOrEqual(repository.notes.values.first!.created, created)
        XCTAssertEqual(repository.notes.values.first!.id, repository.notes.keys.first!)
        XCTAssertEqual(repository.notes.values.first!.id, repository.account.notes.first!)
    }
    
    func testNewNoteCreatesIfNewestHasNoContent() {
        repository.newNote()
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
    }
    
    func testNewNoteCreatesIfNewestHasContent() {
        repository.newNote()
        let note = repository.notes.values.first!
        note.content = "hello world"
        repository.newNote()
        XCTAssertEqual(2, repository.notes.count)
    }
}
