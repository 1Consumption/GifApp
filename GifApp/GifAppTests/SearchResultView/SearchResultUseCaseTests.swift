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
            expectation.fulfill()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                              method: .get,
                              headers: nil)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveGifInfoFailureWithEndOfPageError() {
        let expectation = XCTestExpectation(description: "failure with end of page error")
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
                expectation.fulfill()
            }, successHandler: { _ in
                XCTFail()
            })
        })
        
        wait(for: [expectation], timeout: 2.0)
        
        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                              method: .get,
                              headers: nil)
    }
    
    func testRetrieveGifInfoFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { error in
            XCTAssertEqual(error, .decodeError)
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                              method: .get,
                              headers: nil)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveGifInfoFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: { error in
            XCTAssertEqual(error, .networkError(with: .emptyData))
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                              method: .get,
                              headers: nil)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDuplicateRequest() {
        let expectation = XCTestExpectation(description: "retrieve gifInfo success")
        
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
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: {
            XCTAssertEqual($0, .duplicatedRequest)
        }, successHandler: {
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        useCase.retrieveGifInfo(keyword: "test", failureHandler: {
            XCTAssertEqual($0, .duplicatedRequest)
        }, successHandler: {
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                              method: .get,
                              headers: nil)
        
        wait(for: [expectation], timeout: 3.0)
    }
}
