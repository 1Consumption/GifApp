//
//  SearchResultUseCaseTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class SearchResultUseCaseTests: XCTestCase {

    func testRetrieveGifInfoSuccess() {
        let expectation = XCTestExpectation(description: "retrieve gifInfo success")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                   username: "test",
                                                   source: "test",
                                                   images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")))],
                                    pagination: Pagination(totalCount: 0, count: 0, offset: 0))
        let data = try! JSONEncoder().encode(model)
        let networkManager = MockSuccessNetworkManager(data: data)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            XCTAssertEqual(model, $0)
            networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                  method: .get,
                                  headers: nil)
            expectation.fulfill()
        })
    }
    
    func testRetrieveGifInfoFailureWithEndOfPageError() {
        let expectation = XCTestExpectation(description: "failure with end of page error")
        defer { wait(for: [expectation], timeout: 2.0) }
        expectation.expectedFulfillmentCount = 2
        
        let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                   username: "test",
                                                   source: "test",
                                                   images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")))],
                                    pagination: Pagination(totalCount: 1, count: 1, offset: 0))
        let data = try! JSONEncoder().encode(model)
        let networkManager = MockSuccessNetworkManager(data: data)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            XCTAssertEqual(model, $0)
            expectation.fulfill()
            
            let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                       username: "test",
                                                       source: "test",
                                                       images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")))],
                                        pagination: Pagination(totalCount: 1, count: 1, offset: 1))
            let data = try! JSONEncoder().encode(model)
            networkManager.data = data
            useCase.retrieveGifInfo(keyword: "test", failureHandler: {
                XCTAssertEqual($0, UseCaseError.endOfPage)
                networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                      method: .get,
                                      headers: nil)
                expectation.fulfill()
            }, successHandler: { _ in
                XCTFail()
            })
        })
    }
    
    func testRetrieveGifInfoFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { error in
            networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                  method: .get,
                                  headers: nil)
            XCTAssertEqual(error, .decodeError)
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
    }
    
    func testRetrieveGifInfoFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { error in
            networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                  method: .get,
                                  headers: nil)
            XCTAssertEqual(error, .networkError(with: .emptyData))
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
    }
    
    func testDuplicateRequest() {
        let expectation = XCTestExpectation(description: "retrieve gifInfo success")
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                   username: "test",
                                                   source: "test",
                                                   images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")))],
                                    pagination: Pagination(totalCount: 0, count: 0, offset: 0))
        let data = try! JSONEncoder().encode(model)
        let networkManager = MockSuccessNetworkManager(data: data, delay: .now() + 1)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                  method: .get,
                                  headers: nil)
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: {
            XCTAssertEqual($0, .duplicatedRequest)
        }, successHandler: { _ in
            XCTFail()
        })
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: {
            XCTAssertEqual($0, .duplicatedRequest)
        }, successHandler: { _ in
            XCTFail()
        })
    }
}
