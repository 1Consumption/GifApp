//
//  SearchResultViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class SearchResultViewModelTests: XCTestCase {
    
    private let input: SearchResultViewModelInput = SearchResultViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    private var viewModel: SearchResultViewModel!
    
    func testNextPageDelivered() {
        let expactation = XCTestExpectation(description: "next page delivered")
        defer { wait(for: [expactation], timeout: 1.0) }
        
        let useCase = MockSuccessSearchResultUseCase()
        viewModel = SearchResultViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).nextPageDelivered
        output.bind {
            useCase.verify(keyword: "test")
            XCTAssertEqual($0, [IndexPath(row: 0, section: 0)])
            expactation.fulfill()
        }.store(in: &bag)
        
        input.nextPageRequest.value = "test"
    }
    
    func testErrorDelivered() {
        let expactation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expactation], timeout: 1.0) }
        
        let useCase = MockFailureSearchResultUseCase(error: .decodeError)
        viewModel = SearchResultViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).errorDelivered
        output.bind {
            useCase.verify(keyword: "test")
            XCTAssertEqual($0, .decodeError)
            expactation.fulfill()
        }.store(in: &bag)
        
        input.nextPageRequest.value = "test"
    }
    
    func testShowDetailFired() {
        let expactation = XCTestExpectation(description: "show detail fired")
        defer { wait(for: [expactation], timeout: 1.0) }
        
        let useCase = DummySearchResultUseCase()
        viewModel = SearchResultViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).showDetailFired
        output.bind {
            XCTAssertEqual($0, IndexPath(item: 0, section: 0))
            expactation.fulfill()
        }.store(in: &bag)
        
        input.showDetail.value = IndexPath(item: 0, section: 0)
    }
}
