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
        
        let testModel = GifInfoResponse(data: [GifInfo(id: "1",
                                                       username: "test",
                                                       source: "test",
                                                       images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")),
                                                       user: User(avatarUrl: "", username: "", displayName: ""))],
                                        pagination: Pagination(totalCount: 0, count: 0, offset: 0))
        let data = try! JSONEncoder().encode(testModel)
        let networkManager = MockSuccessNetworkManager(data: data)
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo { result in
            switch result {
            case .success(let model):
                networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                                      method: .get,
                                      headers: nil)
                XCTAssertEqual(testModel, model)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testRetrieveGifInfoFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failure with decode error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithDecodeError()
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                                      method: .get,
                                      headers: nil)
                XCTAssertEqual(error, .decodeError)
                expectation.fulfill()
            }
        }
    }
    
    func testRetrieveGifInfoFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failure with network error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        let useCase = TrendingGifUseCase(networkManager: networkManager)
        
        useCase.retrieveGifInfo { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                networkManager.verify(url: EndPoint(urlInfomation: .trending).url,
                                      method: .get,
                                      headers: nil)
                XCTAssertEqual(error, .networkError(with: .emptyData))
                expectation.fulfill()
            }
        }
    }
}
