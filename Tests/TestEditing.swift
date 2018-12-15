import XCTest
@testable import Desktop

class TestEditing:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.update = { _ in }
        repository.select = { _ in }
    }
    
    func testCreateNewOne() {
        let editing = repository.createNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual(editing.id, repository.notes.first!.id)
    }
    
    func testReturnExistingNote() {
        repository.newNote()
        let newNote = repository.notes.first!
        let editing = repository.createNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual(newNote.id, editing.id)
    }
    
    func testReturnLastCreatedNote() {
        repository.newNote()
        let firstNote = repository.notes.first!
        firstNote.created = 0
        firstNote.content = "hello world"
        repository.newNote()
        let lastNote = repository.notes.sorted(by: { $0.created > $1.created } ).first!
        let editing = repository.createNote()
        XCTAssertGreaterThan(editing.created, 0)
        XCTAssertEqual(lastNote.id, editing.id)
    }
    
    func testCreateNewOneIfLastHasContent() {
        repository.newNote()
        let contentNote = repository.notes.first!
        contentNote.content = "hello world"
        let editing = repository.createNote()
        XCTAssertEqual(2, repository.notes.count)
        XCTAssertNotEqual(contentNote.id, editing.id)
    }
}
