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
    private var viewModel: TrendingGifViewModel!
    
    func testViewModelOutputGifInfoDelivered() {
        let expectation = XCTestExpectation(description: "gifInfo delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessTrendingUseCase()
        viewModel = TrendingGifViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).gifInfoDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGifInfo.fire()
    }
    
    func testViewModelOutputErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureTrendingUseCase()
        viewModel = TrendingGifViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGifInfo.fire()
    }
    
    func testGifInfoOfIndex() {
        let expectation = XCTestExpectation(description: "gifInfo of Index")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessTrendingUseCase()
        viewModel = TrendingGifViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).gifInfoDelivered
        
        output.bind { _ in
            XCTAssertNotNil(self.viewModel.gifInfo(of: 0))
            XCTAssertNil(self.viewModel.gifInfo(of: 1))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGifInfo.fire()
    }
}
