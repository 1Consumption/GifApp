//
//  ObservableTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class ObservableTests: XCTestCase {

    private var bag: CancellableBag = CancellableBag()
    
    func testBind() {
        let expectation = XCTestExpectation(description: "bind")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let observable = Observable<Int>(value: 0)
        
        var value = 5
        
        observable.bind {
            XCTAssertEqual($0, value)
            expectation.fulfill()
        }.store(in: &bag)
        
        observable.value = value
        
        value = 10
        observable.value = value
    }
}
