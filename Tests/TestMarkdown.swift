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
        XCTAssertEqual(NSRange(0, 10), traits[0].range)
    }
}
