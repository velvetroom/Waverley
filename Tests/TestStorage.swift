import XCTest
@testable import Mobile

class TestStorage:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!

    override func setUp() {
        repository = Factory.makeRepository()
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
}
