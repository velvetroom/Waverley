import XCTest
@testable import Desktop

class TestNote:XCTestCase {
    private var data:Data!
    private let json = """
{
"id":"lorem ipsum",
"created": 123.0,
"synchstamp": 345.0,
"content": "hello world"
}
"""
    override func setUp() {
        data = json.data(using:.utf8)
    }

    func testParsing() {
        let note = try! JSONDecoder().decode(Note.self, from:data)
        XCTAssertEqual("lorem ipsum", note.id)
        XCTAssertEqual(123.0, note.created)
        XCTAssertEqual(345.0, note.synchstamp)
        XCTAssertEqual("hello world", note.content)
    }
}
