// The MIT License (MIT)
//
// Copyright (c) 2017 Caleb Kleveter
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// Any errors that occur in the code of the Retry library.
public enum RecoveryError: Error {
    
    /// Thrown if a finite retry loop fails to recover the throwing block passed in.
    case failedToRecover
}

/// The type of recovery loop to run on the throwing block.
public enum RecoveryTimes {
    
    /// Run recovery loop until the the throwing block completes.
    case infinite
    
    /// Run the recovery loop a maximum amount of times
    case finite(Int)
}

/// Run a block that can throw until it succedes without throwing or the recovery loop completes.
///
/// - Parameters:
///   - block: The code to try to run.
///   - times: The numbers of times to run the retry loop.
///   - recovery: A block to run between code failures.
/// - Returns: What is returned from the block.
/// - Throws: RecoveryError.failedToRecover if the recovery loop completes and fails to recover. This only occurs with a finite recovery time.
public func retry<T>(_ block: ()throws -> T, times: RecoveryTimes, withRecovery recovery: (Error) -> ())throws -> T {
    switch times {
    case .infinite:
    while true {
        do {
            let result = try block()
            return result
        } catch let error {
            recovery(error)
        }
    }
    case let .finite(runTimes):
        for _ in 0..<runTimes {
            do {
                let result = try block()
                return result
            } catch let error {
                recovery(error)
            }
        }
        throw RecoveryError.failedToRecover
    }
}

/// Run a block that can throw until it succedes without throwing or the recovery loop completes.
///
/// - Parameters:
///   - block: The code to try to run.
///   - times: The numbers of times to run the retry loop.
///   - recovery: A block to run between code failures.
/// - Returns: What is returned from the block.
/// - Throws: RecoveryError.failedToRecover if the recovery loop completes and fails to recover. This only occurs with a finite recovery time.
public func retry<T>(_ block: ()throws -> T, times: Int, withRecovery recovery: (Error) -> ())throws -> T {
    return try retry(block, times: .finite(times), withRecovery: recovery)
}
