import XCTest
@testable import Desktop

class TestStorage:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!

    override func setUp() {
        repository = Repository()
        storage = MockStorage()
        repository.synch = MockSynch()
        repository.storage = storage
        repository.update = { _ in }
        repository.select = { _ in }
    }
    
    func testLoadGetsAccount() {
        let expect = expectation(description:String())
        storage.onAccount = { expect.fulfill() }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNoAccountSaves() {
        let expect = expectation(description:String())
        storage.error = Exception.accountNotFound
        storage.onSaveAccount = { expect.fulfill() }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testLoadNotes() {
        let expect = expectation(description:String())
        storage.returnAccount.notes = ["lorem"]
        storage.onNote = { id in
            XCTAssertEqual("lorem", id)
            expect.fulfill()
        }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNewNoteSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.newNote()
        waitForExpectations(timeout:1)
    }
    
    func testNewNoteSavesNote() {
        let expect = expectation(description:String())
        storage.onSaveNote = { expect.fulfill() }
        repository.newNote()
        waitForExpectations(timeout:1)
    }
    
    func testUpdateContentSavesNote() {
        let expect = expectation(description:String())
        storage.onSaveNote = { expect.fulfill() }
        repository.update(Note(), content:"hello world")
        waitForExpectations(timeout:1)
    }

    func testDeleteNoteSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        let note = Note()
        note.id = "a"
        repository.notes.append(Note())
        repository.notes.append(note)
        repository.delete(note)
        waitForExpectations(timeout:1)
    }
    
    func testDeleteNoteRemovesNote() {
        let expect = expectation(description:String())
        storage.onDeleteNote = { expect.fulfill() }
        let note = Note()
        repository.notes.append(note)
        repository.delete(note)
        waitForExpectations(timeout:1)
    }
    
    func testRateSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.account.created = 3
        _ = repository.rate()
        waitForExpectations(timeout:1)
    }
    
    func testNotRateSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        _ = repository.rate()
        waitForExpectations(timeout:1)
    }
}
