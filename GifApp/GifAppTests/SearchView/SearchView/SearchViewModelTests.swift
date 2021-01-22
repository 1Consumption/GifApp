//
//  SearchViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class SearchViewModelTests: XCTestCase {
    
    private let input: SearchViewModelInput = SearchViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    private var viewModel: SearchViewModel!
    
    func testEditingStateChanged() {
        let expectation = XCTestExpectation(description: "editing state changed")
        defer { wait(for: [expectation], timeout: 1.0) }
        expectation.expectedFulfillmentCount = 2
        
        let useCase = DummyAutoCompleteUseCase()
        viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).searchTextFieldIsEmpty
        
        var value = ""
        
        output.bind {
            XCTAssertEqual($0, value.isEmpty)
            expectation.fulfill()
        }.store(in: &bag)
        
        value = "1"
        input.isEditing.value = value
        
        value = ""
        input.isEditing.value = value
    }
    
    func testAutoCompleteDelivered() {
        let expectation = XCTestExpectation(description: "autoComplete delivered")
        defer { wait(for: [expectation], timeout: 2.0) }
        
        let useCase = MockSuccessAutoCompleteUseCase()
        viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).autoCompleteDelivered
        
        output.bind {
            useCase.verify(keyword: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldChanged.value = "t"
        input.textFieldChanged.value = "te"
        input.textFieldChanged.value = "tes"
        input.textFieldChanged.value = "test"
    }
    
    func testErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expectation], timeout: 2.0) }
        
        let useCase = MockFailureAutoCompleteUseCase()
        viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind {
            useCase.verify(keyword: "test")
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldChanged.value = "test"
    }
    
    func testSearchFired() {
        let expectation = XCTestExpectation(description: "search fired")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = DummyAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).searchFired
        
        output.bind {
            XCTAssertEqual($0, "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.searchFire.value = "test"
    }
    
    func testKeyword() {
        let expectation = XCTestExpectation(description: "keyword")
        defer { wait(for: [expectation], timeout: 1.0) }
        let useCase = MockSuccessAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).autoCompleteDelivered
        
        output.bind {
            XCTAssertNotNil(viewModel.keyword(of: 0))
            XCTAssertNil(viewModel.keyword(of: 1))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldChanged.value = "test"
    }
}
