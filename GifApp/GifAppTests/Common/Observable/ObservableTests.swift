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
        defer { wait(for: [expectation], timeout: 1.0) }
        expectation.expectedFulfillmentCount = 2
        
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
    
    func testFire() {
        let expectation = XCTestExpectation(description: "fire")
        defer { wait(for: [expectation], timeout: 1.0) }
        expectation.expectedFulfillmentCount = 2
        
        let observable = Observable<Void>(value: ())
        
        observable.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        observable.fire()
        observable.fire()
    }
    
    func testMutlipleBind() {
        let expectation = XCTestExpectation(description: "mutiple bind")
        defer { wait(for: [expectation], timeout: 1.0) }
        expectation.expectedFulfillmentCount = 4
        
        let observable = Observable<Void>(value: ())
        
        observable.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        observable.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        observable.fire()
        observable.fire()
    }
}
