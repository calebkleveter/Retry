import XCTest
@testable import Retry

class RetryTests: XCTestCase {
    func testRetryThrow() {
        do {
            try retry({
                throw RecoveryError.failedToRecover
            }, times: 5, withRecovery: { (error) in })
            XCTFail()
        } catch {}
    }

    func notThrow() throws {}
    
    func testRetrySuccess() {
        do {
            try retry({
                try notThrow()
            }, times: 5, withRecovery: { (error) in })
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    static var allTests = [
        ("testRetryThrow", testRetryThrow),
    ]
}
