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
        expectation.expectedFulfillmentCount = 2
        
        let debounce = Debounce<Int>(value: 0, wait: 0.3)
        
        var value = 0
        
        debounce.bind {
            XCTAssertEqual($0, value)
            expectation.fulfill()
        }.store(in: &bag)
        
        value = 1
        debounce.value = value
        
        value = 2
        debounce.value = value
        
        value = 3
        debounce.value = value
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            value = 4
            debounce.value = value
            
            value = 5
            debounce.value = value
        })
        
        
        wait(for: [expectation], timeout: 2.0)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            debounce.fire()
        })
        
        wait(for: [expectation], timeout: 2.0)
    }
}
