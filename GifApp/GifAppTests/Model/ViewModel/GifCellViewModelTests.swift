//
//  GifCellViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class GifCellViewModelTests: XCTestCase {
 
    private let input: GifCellViewModelInput = GifCellViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    func testViewModelOutputGifInfoDelivered() {
        let expectation = XCTestExpectation(description: "gif delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let viewModel = GifCellViewModel()
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
}
