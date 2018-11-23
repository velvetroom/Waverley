import XCTest
@testable import Mobile

class TestFactory:XCTestCase {
    func testRepositoryMonostate() {
        XCTAssertTrue(Factory.makeRepository() === Factory.makeRepository())
    }
}
