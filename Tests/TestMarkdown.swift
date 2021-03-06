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
    
    func testHeader() {
        let traits = mark.parse("# hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(10, traits[0].addSize)
    }
    
    func testSubheader() {
        let traits = mark.parse("## hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(4, traits[0].addSize)
    }
    
    func testSubheaderMultiple() {
        let traits = mark.parse("### hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("# hello world", traits[0].string)
        XCTAssertEqual(4, traits[0].addSize)
    }
    
    func testHeaderNoSpace() {
        let traits = mark.parse("#hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("hello world", traits[0].string)
        XCTAssertEqual(10, traits[0].addSize)
    }
    
    func testHeaderAndContent() {
        let traits = mark.parse("# hello world\nlorem ipsum")
        XCTAssertEqual(2, traits.count)
        XCTAssertEqual(Trait.Mode.bold, traits[0].mode)
        XCTAssertEqual("hello world\n", traits[0].string)
        XCTAssertEqual(10, traits[0].addSize)
        XCTAssertEqual(Trait.Mode.regular, traits[1].mode)
        XCTAssertEqual("lorem ipsum", traits[1].string)
        XCTAssertEqual(0, traits[1].addSize)
    }
    
    func testStar() {
        let traits = mark.parse("*hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.regular, traits[0].mode)
        XCTAssertEqual("*hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
    
    func testUnderscore() {
        let traits = mark.parse("_hello world")
        XCTAssertEqual(1, traits.count)
        XCTAssertEqual(Trait.Mode.regular, traits[0].mode)
        XCTAssertEqual("_hello world", traits[0].string)
        XCTAssertEqual(0, traits[0].addSize)
    }
}
