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
    private var debounce: Debounce<Int>!
    private var debounceVoid: Debounce<Void>!
    
    func testBind() {
        let expectation = XCTestExpectation(description: "bind")
        defer { wait(for: [expectation], timeout: 2.0) }
        expectation.expectedFulfillmentCount = 2
        
        debounce = Debounce<Int>(value: 0, wait: 0.3)
        
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
            self.debounce.value = value
            
            value = 5
            self.debounce.value = value
        })
    }
    
    func testFire() {
        let expectation = XCTestExpectation(description: "fire")
        defer { wait(for: [expectation], timeout: 2.0) }
        expectation.expectedFulfillmentCount = 2
        
        debounceVoid = Debounce<Void>(value: (), wait: 0.3)
        
        debounceVoid.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        debounceVoid.fire()
        debounceVoid.fire()
        debounceVoid.fire()
        debounceVoid.fire()
        debounceVoid.fire()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.debounceVoid.fire()
        })
    }
}
