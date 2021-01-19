//
//  MockSuccessRequester.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class MockSuccessRequester: RequesterType {
    
    private var reuqest: URLRequest!
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.reuqest = request
        
        return MockURLSessionDataTask {
            completionHandler(Data(), nil, nil)
        }
    }
    
    func verify(request: URLRequest) {
        XCTAssertEqual(self.reuqest, request)
    }
}
