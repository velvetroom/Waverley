import XCTest
@testable import Desktop

class TestMarkdown:XCTestCase {
    private var mark:Markdown!
    
    override func setUp() {
        mark = Markdown()
    }
    
    func testPlainString() {
        let traits = mark.parse("hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.regular, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
}
