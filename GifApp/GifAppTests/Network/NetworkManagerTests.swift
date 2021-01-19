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
                                    expectation.fulfill()
                                })
        
        requester.verify(request: request)
    }
}
