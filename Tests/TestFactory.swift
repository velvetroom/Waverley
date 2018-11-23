import XCTest
@testable import Desktop

class TestFactory:XCTestCase {
    func testRepositoryMonostate() {
        XCTAssertTrue(Factory.makeRepository() === Factory.makeRepository())
    }
}
