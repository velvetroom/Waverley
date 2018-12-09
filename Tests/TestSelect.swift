import XCTest
@testable import Desktop

class TestSelect:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    
    override func setUp() {
        repository = Repository()
        storage = MockStorage()
        Factory.storage = storage
        repository.update = { _ in }
    }
    
    override func tearDown() {
        Factory.storage = MockStorage()
    }
    
    func testLoadSelects() {
        let expect = expectation(description:String())
        repository.select = { note in
            XCTAssertTrue(self.repository.notes.first! === note)
            expect.fulfill()
        }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNext() {
        let expect = expectation(description:String())
        let a = Note()
        let b = Note()
        repository.select = { note in
            XCTAssertTrue(b === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.notes.append(b)
        repository.next(a)
        waitForExpectations(timeout:1)
    }
    
    func testNextOneItem() {
        let expect = expectation(description:String())
        let a = Note()
        repository.select = { note in
            XCTAssertTrue(a === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.next(a)
        waitForExpectations(timeout:1)
    }
    
    func testNextLastItem() {
        let expect = expectation(description:String())
        let a = Note()
        let b = Note()
        repository.select = { note in
            XCTAssertTrue(a === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.notes.append(b)
        repository.next(b)
        waitForExpectations(timeout:1)
    }
    
    func testPrevious() {
        let expect = expectation(description:String())
        let a = Note()
        let b = Note()
        repository.select = { note in
            XCTAssertTrue(a === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.notes.append(b)
        repository.previous(b)
        waitForExpectations(timeout:1)
    }
    
    func testPreviousOneItem() {
        let expect = expectation(description:String())
        let a = Note()
        repository.select = { note in
            XCTAssertTrue(a === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.previous(a)
        waitForExpectations(timeout:1)
    }
    
    func testPreviousFirstItem() {
        let expect = expectation(description:String())
        let a = Note()
        let b = Note()
        repository.select = { note in
            XCTAssertTrue(b === note)
            expect.fulfill()
        }
        repository.notes.append(a)
        repository.notes.append(b)
        repository.next(a)
        waitForExpectations(timeout:1)
    }
}
