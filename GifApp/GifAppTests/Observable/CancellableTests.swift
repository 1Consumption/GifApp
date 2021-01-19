//
//  CancellableTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class CancellableTests: XCTestCase {
    
    func testCancel() {
        let expectation = XCTestExpectation(description: "cancel")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let cancellable = Cancellable {
            expectation.fulfill()
        }
        
        cancellable.cancel()
    }
}
