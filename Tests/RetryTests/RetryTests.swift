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

    static var allTests = [
        ("testRetryThrow", testRetryThrow),
    ]
}
