import XCTest
@testable import Desktop

class TestRepository:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.update = { _ in }
        repository.select = { _ in }
    }
    
    func testNewNote() {
        let created = Date().timeIntervalSince1970
        repository.newNote()
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertFalse(repository.notes.first!.id.isEmpty)
        XCTAssertGreaterThanOrEqual(repository.notes.first!.created, created)
        XCTAssertGreaterThanOrEqual(repository.notes.first!.synchstamp, created)
        XCTAssertEqual(repository.notes.first!.id, repository.account.notes.first!)
    }
    
    func testNewNoteCreatesIfAllHaveContent() {
        repository.newNote()
        let note = repository.notes.first!
        note.content = "hello world"
        repository.newNote()
        XCTAssertEqual(2, repository.notes.count)
        XCTAssertTrue(note === repository.notes[1])
    }
    
    func testNewNoteNotCreatesIfAnyHasNoContent() {
        let noteA = Note()
        let noteB = Note()
        noteA.content = "lorem ipsum"
        noteB.content = "hello world"
        repository.notes = [noteB, Note(), noteA]
        repository.newNote()
        XCTAssertEqual(3, repository.notes.count)
    }
    
    func testUpdateContent() {
        let note = Note()
        let synchstamp = Date().timeIntervalSince1970
        repository.update(note, content:"hello world")
        XCTAssertEqual("hello world", note.content)
        XCTAssertGreaterThanOrEqual(note.synchstamp, synchstamp)
        XCTAssertNotEqual(note.synchstamp, note.created)
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
