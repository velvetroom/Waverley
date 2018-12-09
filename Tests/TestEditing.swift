import XCTest
@testable import Desktop

class TestEditing:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        Factory.storage = MockStorage()
    }
    
    func testCreateNewOne() {
        let editing = repository.editing()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual(editing.id, repository.notes.values.first!.id)
    }
    
    func testReturnExistingNote() {
        repository.newNote()
        let newNote = repository.notes.values.first!
        let editing = repository.editing()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual(newNote.id, editing.id)
    }
    
    func testReturnLastCreatedNote() {
        repository.newNote()
        let firstNote = repository.notes.values.first!
        firstNote.created = 0
        firstNote.content = "hello world"
        repository.newNote()
        let lastNote = repository.notes.values.sorted(by: { $0.created > $1.created } ).first!
        let editing = repository.editing()
        XCTAssertGreaterThan(editing.created, 0)
        XCTAssertEqual(lastNote.id, editing.id)
    }
    
    func testCreateNewOneIfLastHasContent() {
        repository.newNote()
        let contentNote = repository.notes.values.first!
        contentNote.content = "hello world"
        let editing = repository.editing()
        XCTAssertEqual(2, repository.notes.count)
        XCTAssertNotEqual(contentNote.id, editing.id)
    }
}
