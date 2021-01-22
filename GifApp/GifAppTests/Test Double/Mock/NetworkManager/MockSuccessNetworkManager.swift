//
//  MockSuccessNetworkManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class MockSuccessNetworkManager: NetworkManagerType {
    
    var requester: RequesterType
    var data: Data
    
    private var url: URL?
    private var method: HTTPMethod?
    private var headers: [String: String]?
    private var callCount: Int = 0
    private var delay: DispatchTime
    
    init(data: Data, delay: DispatchTime = .now()) {
        self.data = data
        self.delay = delay
        requester = DummyRequester()
    }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String : String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        self.url = url
        self.method = method
        self.headers = headers
        callCount += 1
        
        DispatchQueue.global().asyncAfter(deadline: delay) {
            completionHandler(.success(self.data))
        }
        
        return nil
    }
    
    func verify(url: URL?, method: HTTPMethod?, headers: [String: String]?, callCount: Int = 1) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.method, method)
        XCTAssertEqual(self.headers, headers)
        XCTAssertEqual(self.callCount, callCount)
    }
}
