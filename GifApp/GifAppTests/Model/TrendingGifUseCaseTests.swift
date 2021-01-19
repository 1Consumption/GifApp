//
//  TrendingGifUseCaseTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class TrendingGifUseCaseTests: XCTestCase {
    
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
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            XCTAssertEqual(model, $0)
            expectation.fulfill()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                              method: .get,
                              headers: nil)
    }
    
    func testRetrieveGifInfoFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(failureHandler: { error in
            XCTAssertEqual(error, .decodeError)
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                              method: .get,
                              headers: nil)
    }
    
    func testRetrieveGifInfoFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo(failureHandler: { error in
            XCTAssertEqual(error, .networkError(with: .emptyData))
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
        
        networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                              method: .get,
                              headers: nil)
    }
}
