//
//  TrendingGifViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class TrendingGifViewModelTests: XCTestCase {
    
    private let input: TrendingGifViewModelInput = TrendingGifViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    func testViewModelOutputGifInfoDelivered() {
        let expectation = XCTestExpectation(description: "gifInfo delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        let useCase = MockSuccessTrendingUseCase()
        let viewModel = TrendingGifViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).gifInfoDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGifInfo.fire()
    }
}
