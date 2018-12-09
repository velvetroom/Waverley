import XCTest
@testable import Desktop

class TestUpdate:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    
    override func setUp() {
        repository = Repository()
        storage = MockStorage()
        Factory.storage = storage
        repository.select = { _ in }
    }
    
    override func tearDown() {
        Factory.storage = MockStorage()
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
