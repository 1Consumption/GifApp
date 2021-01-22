//
//  AutoCompleteUseCaseTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class AutoCompleteUseCaseTests: XCTestCase {

    func testRetrieveAutoCompleteSuccess() {
        let expectation = XCTestExpectation(description: "retrieve autoComplete success")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let model = AutoCompleteResponse(data: [AutoComplete(name: "test")])
        let data = try! JSONEncoder().encode(model)
        let networkManager = MockSuccessNetworkManager(data: data)
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test", failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                              method: .get,
                              headers: nil)
    }
    
    func testRetrieveAutoCompleteFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test", failureHandler: { error in
            XCTAssertEqual(error, .decodeError)
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                              method: .get,
                              headers: nil)
    }
    
    func testRetrieveAutoCompleteFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test", failureHandler: { error in
            XCTAssertEqual(error, .networkError(with: .emptyData))
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                              method: .get,
                              headers: nil)
    }
}
