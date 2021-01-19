//
//  NetworkManagerTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class NetworkManagerTests: XCTestCase {
    //    RequestType을 채택한 변수를 프로퍼티로 가짐
    //    Result<Data, NetworkError>을 completionHandler로 전달하는 메소드 제공
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        var request = URLRequest(url: URL(string: "test")!)
        request.addValue("test", forHTTPHeaderField: "test")
        let requester = MockSuccessRequester()
        let networkManager = NetworkManager(requester: requester)
        
        let _ = networkManager.loadData(with: request.url,
                                        method: HTTPMethod(rawValue: request.httpMethod!)!,
                                        headers: request.allHTTPHeaderFields,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(_):
                                                expectation.fulfill()
                                            case .failure(_):
                                                XCTFail()
                                            }
                                        })
        
        requester.verify(request: request)
    }
    
    func testFailureWithEmptyURL() {
        let expectation = XCTestExpectation(description: "failure with empty url")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = NetworkManager()
        
        let _ = networkManager.loadData(with: URL(string: ""),
                                        method: .get,
                                        headers: nil,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(_):
                                                XCTFail()
                                            case .failure(let error):
                                                XCTAssertEqual(error, NetworkError.emptyURL)
                                                expectation.fulfill()
                                            }
                                        })
    }
    
    func testFailureWithError() {
        let expectation = XCTestExpectation(description: "failure with empty url")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let request = URLRequest(url: URL(string: "test")!)
        let requester = MockFailureWithRequestErrorRequester()
        let networkManager = NetworkManager(requester: requester)
        
        let _ = networkManager.loadData(with: request.url,
                                        method: HTTPMethod(rawValue: request.httpMethod!)!,
                                        headers: nil,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(_):
                                                XCTFail()
                                            case .failure(let error):
                                                XCTAssertEqual(error, NetworkError.requestError(description: "error"))
                                                expectation.fulfill()
                                            }
                                        })
        
        requester.verify(request: request)
    }
    
    func testFailureWithNonHTTPResponseError() {
        let expectation = XCTestExpectation(description: "failure with non HTTP response error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let request = URLRequest(url: URL(string: "test")!)
        let requester = MockFailureWithNonHTTPResponseErrorRequester()
        let networkManager = NetworkManager(requester: requester)
        
        let _ = networkManager.loadData(with: request.url,
                                        method: HTTPMethod(rawValue: request.httpMethod!)!,
                                        headers: nil,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(_):
                                                XCTFail()
                                            case .failure(let error):
                                                XCTAssertEqual(error, NetworkError.nonHTTPResponseError)
                                                expectation.fulfill()
                                            }
                                        })
        
        requester.verify(request: request)
    }
}
