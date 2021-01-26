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
        
        let testModel = AutoCompleteResponse(data: [AutoComplete(name: "test")])
        let data = try! JSONEncoder().encode(testModel)
        let networkManager = MockSuccessNetworkManager(data: data)
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test",
                                     completionHandler: { result in
                                        switch result {
                                        case .success(let model):
                                            networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                                                                  method: .get,
                                                                  headers: nil)
                                            XCTAssertEqual(testModel, model)
                                            expectation.fulfill()
                                        case .failure:
                                            XCTFail()
                                        }
                                     })
    }
    
    func testRetrieveAutoCompleteFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test",
                                     completionHandler: { result in
                                        switch result {
                                        case .success:
                                            XCTFail()
                                        case .failure(let error):
                                            networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                                                                  method: .get,
                                                                  headers: nil)
                                            XCTAssertEqual(error, .decodeError)
                                            expectation.fulfill()
                                        }
                                     })
    }
    
    func testRetrieveAutoCompleteFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = AutoCompleteUseCase(networkManager: networkManager)
        
        useCase.retrieveAutoComplete(keyword: "test",
                                     completionHandler: { result in
                                        switch result {
                                        case .success:
                                            XCTFail()
                                        case .failure(let error):
                                            networkManager.verify(url: EndPoint(urlInfomation: .autoComplete(keyword: "test")).url,
                                                                  method: .get,
                                                                  headers: nil)
                                            XCTAssertEqual(error, .networkError(with: .emptyData))
                                            expectation.fulfill()
                                        }
                                     })
    }
}
