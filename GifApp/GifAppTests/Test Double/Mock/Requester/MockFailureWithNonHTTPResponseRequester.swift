//
//  MockFailureWithNonHTTPResponseRequester.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class MockFailureWithNonHTTPResponseRequester: RequesterType {

    private var reuqest: URLRequest!
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.reuqest = request
        
        return MockURLSessionDataTask {
            completionHandler(nil, URLResponse(url: URL(string: "test")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil), nil)
        }
    }
    
    func verify(request: URLRequest) {
        XCTAssertEqual(self.reuqest, request)
    }
}
