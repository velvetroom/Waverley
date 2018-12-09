import XCTest
@testable import Desktop

class TestRepository:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        Factory.storage = MockStorage()
        repository.update = { _ in }
        repository.select = { _ in }
    }
    
    override func tearDown() {
        Factory.storage = MockStorage()
    }
    
    func testNewNote() {
        let created = Date().timeIntervalSince1970
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertFalse(repository.notes.first!.id.isEmpty)
        XCTAssertGreaterThanOrEqual(repository.notes.first!.created, created)
        XCTAssertEqual(repository.notes.first!.id, repository.account.notes.first!)
    }
    
    func testNewNoteNotCreatesIfNewestHasNoContent() {
        repository.newNote()
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
    }
    
    func testNewNoteCreatesIfNewestHasContent() {
        repository.newNote()
        let note = repository.notes.first!
        note.content = "hello world"
        repository.newNote()
        XCTAssertEqual(2, repository.notes.count)
        XCTAssertTrue(note === repository.notes[1])
    }
    
    func testUpdateContent() {
        let note = Note()
        repository.update(note, content:"hello world")
        XCTAssertEqual("hello world", note.content)
    }
    
    func testDeleteNote() {
        let note = repository.createNote()
        repository.delete(note)
        XCTAssertFalse(repository.notes[0] === note)
        XCTAssertNotEqual(note.id, repository.account.notes[0])
    }
    
    func testKeepOtherNotesOnDelete() {
        let first = repository.createNote()
        first.content = "hello world"
        let second = repository.createNote()
        repository.delete(second)
        XCTAssertFalse(repository.notes.isEmpty)
        XCTAssertFalse(repository.account.notes.isEmpty)
    }
}
