import XCTest
@testable import Desktop

class TestUpdate:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        Factory.storage = MockStorage()
        Factory.synch = MockSynch()
        repository.select = { _ in }
    }
    
    func testLoadUpdates() {
        let expect = expectation(description:String())
        repository.update = { notes in
            XCTAssertEqual(1, notes.count)
            expect.fulfill()
        }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNewUpdates() {
        let expect = expectation(description:String())
        repository.update = { notes in
            XCTAssertEqual(1, notes.count)
            expect.fulfill()
        }
        repository.newNote()
        waitForExpectations(timeout:1)
    }
    
    func testDeleteUpdates() {
        let expect = expectation(description:String())
        let oldNote = Note()
        repository.update = { notes in
            XCTAssertEqual(1, notes.count)
            expect.fulfill()
        }
        repository.notes.append(oldNote)
        repository.delete(oldNote)
        waitForExpectations(timeout:1)
    }
}
