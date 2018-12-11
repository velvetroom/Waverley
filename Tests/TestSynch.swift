import XCTest
@testable import Desktop

class TestSynch:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    private var synch:MockSynch!
    
    override func setUp() {
        repository = Repository()
        synch = MockSynch()
        storage = MockStorage()
        Factory.storage = storage
        Factory.synch = synch
        repository.select = { _ in }
        repository.update = { _ in }
    }
    
    override func tearDown() {
        Factory.synch = MockSynch()
        Factory.storage = MockStorage()
    }
    
    func testUpdateItems() {
        let expectNote = expectation(description:String())
        let expectAccount = expectation(description:String())
        let expectUpdate = expectation(description:String())
        synch.items = ["a":1]
        synch.note = Note()
        synch.onLoad = { id in XCTAssertEqual("a", id) }
        storage.onSaveNote = { expectNote.fulfill() }
        storage.onSaveAccount = { expectAccount.fulfill() }
        repository.update = { notes in
            XCTAssertEqual(1, notes.count)
            expectUpdate.fulfill()
        }
        repository.startSynch()
        waitForExpectations(timeout:1)
    }
    
    func testReplacesIfExist() {
        let syncA = Note()
        syncA.id = "a"
        syncA.synchstamp = 5
        let a = Note()
        a.id = "a"
        repository.account.notes.append(a.id)
        repository.notes.append(a)
        synch.items = [syncA.id:syncA.synchstamp]
        synch.note = syncA
        repository.startSynch()
        XCTAssertEqual(1, repository.account.notes.count)
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual("a", repository.account.notes.first!)
        XCTAssertEqual("a", repository.notes.first!.id)
        XCTAssertEqual(5, repository.notes.first!.synchstamp)
    }
    
    func testNotUpdatingIfCurrentIsSame() {
        let syncA = Note()
        syncA.id = "a"
        syncA.synchstamp = 5
        syncA.content = "lorem ipsum"
        let a = Note()
        a.id = "a"
        a.synchstamp = 5
        a.content = "hello world"
        repository.account.notes.append(a.id)
        repository.notes.append(a)
        synch.items = [syncA.id:syncA.synchstamp]
        synch.note = syncA
        repository.startSynch()
        XCTAssertEqual(1, repository.account.notes.count)
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual("hello world", repository.notes.first!.content)
    }
    
    func testNotUpdatingIfCurrentIsNewer() {
        let syncA = Note()
        syncA.id = "a"
        syncA.synchstamp = 5
        syncA.content = "lorem ipsum"
        let a = Note()
        a.id = "a"
        a.synchstamp = 7
        a.content = "hello world"
        repository.account.notes.append(a.id)
        repository.notes.append(a)
        synch.items = [syncA.id:syncA.synchstamp]
        synch.note = syncA
        repository.startSynch()
        XCTAssertEqual(1, repository.account.notes.count)
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual("hello world", repository.notes.first!.content)
    }
    
    func testNotRemovingIfIcloudFails() {
        let syncA = Note()
        syncA.id = "a"
        syncA.synchstamp = 5
        let a = Note()
        a.content = "hello world"
        a.id = "a"
        a.synchstamp = 1
        repository.account.notes.append(a.id)
        repository.notes.append(a)
        synch.items = [syncA.id:syncA.synchstamp]
        repository.startSynch()
        XCTAssertEqual(1, repository.account.notes.count)
        XCTAssertEqual(1, repository.notes.count)
        XCTAssertEqual("a", repository.account.notes.first!)
        XCTAssertEqual("a", repository.notes.first!.id)
        XCTAssertEqual(1, repository.notes.first!.synchstamp)
        XCTAssertEqual("hello world", repository.notes.first!.content)
    }
    
    func testCreateNoteSavesAccount() {
        let expect = expectation(description:String())
        synch.onSaveAccount = { account in
            XCTAssertEqual(1, account.count)
            XCTAssertFalse(account.first!.key.isEmpty)
            XCTAssertGreaterThan(account.first!.value, 0)
            expect.fulfill()
        }
        _ = repository.createNote()
        waitForExpectations(timeout:1)
    }
    
    func testCreateNoteSavesNote() {
        let expect = expectation(description:String())
        synch.onSaveNote = { note in
            XCTAssertFalse(note.id.isEmpty)
            XCTAssertGreaterThan(note.synchstamp, 0)
            expect.fulfill()
        }
        _ = repository.createNote()
        waitForExpectations(timeout:1)
    }
    
    func testUpdateContentSavesNote() {
        let expect = expectation(description:String())
        synch.onSaveNote = { note in
            XCTAssertEqual("hello world", note.content)
            expect.fulfill()
        }
        repository.update(Note(), content:"hello world")
        waitForExpectations(timeout:1)
    }
    
    func testUpdateContentSavesAccount() {
        let expect = expectation(description:String())
        synch.onSaveAccount = { account in
            expect.fulfill()
        }
        repository.update(Note(), content:"hello world")
        waitForExpectations(timeout:1)
    }
}