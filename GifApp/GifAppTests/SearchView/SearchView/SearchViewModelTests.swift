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
    
    func testEditingStateChanged() {
        let expectation = XCTestExpectation(description: "editing state changed")
        expectation.expectedFulfillmentCount = 2
        
        let useCase = DummyAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
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
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAutoCompleteDelivered() {
        let expectation = XCTestExpectation(description: "autoComplete delivered")
        
        let useCase = MockSuccessAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).autoCompleteDelivered
        
        output.bind {
            useCase.verify(keyword: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldChanged.value = "t"
        input.textFieldChanged.value = "te"
        input.textFieldChanged.value = "tes"
        input.textFieldChanged.value = "test"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        
        let useCase = MockFailureAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind {
            useCase.verify(keyword: "test")
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldChanged.value = "test"

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchFired() {
        let expectation = XCTestExpectation(description: " delivered")
        
        let useCase = DummyAutoCompleteUseCase()
        let viewModel = SearchViewModel(useCase: useCase)
        
        let output = viewModel.transform(input).searchFired
        
        output.bind {
            XCTAssertEqual($0, "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.searchFire.value = "test"
        
        wait(for: [expectation], timeout: 1.0)
    }
}
