//
//  CancellableTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class CancellableTests: XCTestCase {
    
    private var bag: CancellableBag = CancellableBag()
    
    func testCancel() {
        let expectation = XCTestExpectation(description: "cancel")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let cancellable = Cancellable {
            expectation.fulfill()
        }
        
        cancellable.cancel()
    }
    
    func testDeinit() {
        let expectation = XCTestExpectation(description: "deinit")
        defer { wait(for: [expectation], timeout: 1.0) }
        var cancellable: Cancellable? = Cancellable {
            expectation.fulfill()
        }
        
        XCTAssertNotNil(cancellable)
        
        cancellable = nil
    }
    
    func testStore() {
        let expectation = XCTestExpectation(description: "store deinit")
        defer { wait(for: [expectation], timeout: 1.0) }
        var cancellable: Cancellable? = Cancellable {
            expectation.fulfill()
        }
        
        cancellable?.store(in: &bag)
        
        cancellable = nil
        
        bag.removeAll()
    }
}
