import XCTest
@testable import Desktop

class TestMarkdown:XCTestCase {
    private var mark:Markdown!
    
    override func setUp() {
        mark = Markdown()
    }
    
    func testPlain() {
        let traits = mark.parse("hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.regular, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    func testBold() {
        let traits = mark.parse("*hello world*")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    func testItalic() {
        let traits = mark.parse("_hello world_")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.italic, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    func testBoldAndItalic() {
        let traits = mark.parse("*_hello world_*")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.boldItalic, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    func testItalicAndBold() {
        let traits = mark.parse("_*hello world*_")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.boldItalic, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    
}
