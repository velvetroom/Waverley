import XCTest
@testable import Desktop

class TestStorage:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!

    override func setUp() {
        repository = Repository()
        storage = MockStorage()
        Factory.storage = storage
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
        repository.delete(Note())
        waitForExpectations(timeout:1)
    }
    
    func testDeleteNoteRemovesNote() {
        let expect = expectation(description:String())
        storage.onDeleteNote = { expect.fulfill() }
        repository.delete(Note())
        waitForExpectations(timeout:1)
    }
}
