//
//  DebounceTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/21.
//

@testable import GifApp
import XCTest

final class DebounceTests: XCTestCase {

    private var bag: CancellableBag = CancellableBag()
    
    func testBind() {
        let expectation = XCTestExpectation(description: "bind")
        
        let debounce = Debounce<Int>(value: 0, wait: 0.3)
        
        debounce.bind {
            XCTAssertEqual($0, 5)
            expectation.fulfill()
        }.store(in: &bag)
        
        debounce.value = 1
        debounce.value = 2
        debounce.value = 3
        debounce.value = 4
        debounce.value = 5
        
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFire() {
        let expectation = XCTestExpectation(description: "fire")
        expectation.expectedFulfillmentCount = 2
        
        let debounce = Debounce<Void>(value: (), wait: 0.3)
        
        debounce.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        debounce.fire()
        debounce.fire()
        debounce.fire()
        debounce.fire()
        debounce.fire()
        
        sleep(1)
        
        debounce.fire()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
