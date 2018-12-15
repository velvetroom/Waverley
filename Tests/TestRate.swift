import XCTest
@testable import Desktop

class TestRate:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.select = { _ in }
        repository.update = { _ in }
    }
    
    func testNoRateAtFirst() {
        XCTAssertFalse(repository.rate())
    }
    
    func testRateIfMoreContinuesModulesFour() {
        repository.account.created = 3
        XCTAssertTrue(repository.rate())
        XCTAssertFalse(repository.account.rates.isEmpty)
    }
    
    func testNoRateIfRatedRecently() {
        repository.account.created = 3
        repository.account.rates = [Date()]
        XCTAssertFalse(repository.rate())
    }
    
    func testRateIfRatedMoreThan2MonthsAgo() {
        var components = DateComponents()
        components.month = 3
        let date = Calendar.current.date(byAdding:components, to:Date())!
        repository.account.created = 3
        repository.account.rates = [date]
        XCTAssertEqual(date, repository.account.rates.last!)
        XCTAssertTrue(repository.rate())
        XCTAssertNotEqual(date, repository.account.rates.last!)
    }
}
