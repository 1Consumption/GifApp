//
//  SearchResultUseCaseTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class SearchResultUseCaseTests: XCTestCase {
    
    private var testModel: GifInfoResponse!
    private var testModelEndOfPage: GifInfoResponse!
    private var testModelData: Data!
    private var testModelEndOfPageData: Data!
    
    override func setUpWithError() throws {
        testModel = GifInfoResponse(data:
                                        [GifInfo(id: "1",
                                                 username: "test",
                                                 source: "test",
                                                 images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")),
                                                 user: User(avatarUrl: "", username: "", displayName: ""))],
                                    pagination: Pagination(totalCount: 1, count: 0, offset: 0))
        testModelEndOfPage = GifInfoResponse(data:
                                                [GifInfo(id: "1",
                                                         username: "test",
                                                         source: "test",
                                                         images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")),
                                                         user: User(avatarUrl: "", username: "", displayName: ""))],
                                             pagination: Pagination(totalCount: 1, count: 1, offset: 1))
        testModelData = try! JSONEncoder().encode(testModel)
        testModelEndOfPageData = try! JSONEncoder().encode(testModelEndOfPage)
    }
    
    func testRetrieveGifInfoSuccess() {
        let expectation = XCTestExpectation(description: "retrieve gifInfo success")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockSuccessNetworkManager(data: testModelData)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test",
                                completionHandler: { result in
                                    switch result {
                                    case .success(let model):
                                        XCTAssertEqual(self.testModel, model)
                                        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                                              method: .get,
                                                              headers: nil)
                                        expectation.fulfill()
                                    case .failure(_):
                                        XCTFail()
                                    }
                                })
    }
    
    func testRetrieveGifInfoFailureWithEndOfPageError() {
        let expectation = XCTestExpectation(description: "failure with end of page error")
        defer { wait(for: [expectation], timeout: 2.0) }
        expectation.expectedFulfillmentCount = 2
        
        let networkManager = MockSuccessNetworkManager(data: testModelEndOfPageData)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test",
                                completionHandler: { result in
                                    switch result {
                                    case .success(let model):
                                        XCTAssertEqual(self.testModel, model)
                                        expectation.fulfill()
                                    case .failure(_):
                                        XCTFail()
                                    }
                                })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            useCase.retrieveGifInfo(keyword: "test",
                                    completionHandler: { result in
                                        switch result {
                                        case .success(_):
                                            XCTFail()
                                        case .failure(let error):
                                            XCTAssertEqual(error, .endOfPage)
                                            networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                                                  method: .get,
                                                                  headers: nil)
                                            expectation.fulfill()
                                        }
                                    })
        }
    }
    
    func testRetrieveGifInfoFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test",
                                completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, .decodeError)
                                        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                                              method: .get,
                                                              headers: nil)
                                        expectation.fulfill()
                                    }
                                })
    }
    
    func testRetrieveGifInfoFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test",
                                completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, .networkError(with: .emptyData))
                                        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                                              method: .get,
                                                              headers: nil)
                                        expectation.fulfill()
                                    }
                                })
    }
    
    func testDuplicateRequest() {
        let expectation = XCTestExpectation(description: "retrieve gifInfo success")
        expectation.expectedFulfillmentCount = 3
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let data = try! JSONEncoder().encode(testModel)
        let networkManager = MockSuccessNetworkManager(data: data, delay: .now() + 1)
        let useCase = SearchResultUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(keyword: "test",
                                completionHandler: { result in
                                    switch result {
                                    case .success(let model):
                                        networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                                              method: .get,
                                                              headers: nil)
                                        XCTAssertEqual(self.testModel, model)
                                        expectation.fulfill()
                                    case .failure(_):
                                        XCTFail()
                                    }
                                })
        
        useCase.retrieveGifInfo(keyword: "test", completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .duplicatedRequest)
                networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                      method: .get,
                                      headers: nil)
                expectation.fulfill()
            }
        })
        
        useCase.retrieveGifInfo(keyword: "test", completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .duplicatedRequest)
                networkManager.verify(url: EndPoint(urlInfomation: .search(keyword: "test", offset: 0)).url,
                                      method: .get,
                                      headers: nil)
                expectation.fulfill()
            }
        })
    }
}
