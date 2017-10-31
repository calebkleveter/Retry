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
    
    func testRetryFix() {
        var index = 0
        do {
            let newdex = try retry({ () -> Int in
                if index < 10 {
                    throw RecoveryError.failedToRecover
                }
                return index
            }, times: .infinite, withRecovery: { (error) in
                index += 1
            })
            XCTAssert(newdex == 10)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    static var allTests = [
        ("testRetryThrow", testRetryThrow),
        ("testRetrySuccess", testRetrySuccess),
        ("testRetryFix", testRetryFix)
    ]
}
