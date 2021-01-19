//
//  MockFailureNetworkManagerWithNetworkError.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class MockFailureNetworkManagerWithNetworkError: NetworkManagerType {
    
    var requester: RequesterType
    
    private var url: URL?
    private var method: HTTPMethod?
    private var headers: [String: String]?
    
    init() {
        requester = DummyRequester()
    }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String : String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        self.url = url
        self.method = method
        self.headers = headers
        
        completionHandler(.failure(.emptyData))
        
        return nil
    }
    
    func verify(url: URL?, method: HTTPMethod, headers: [String: String]?) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.method, method)
        XCTAssertEqual(self.headers, headers)
    }
}
