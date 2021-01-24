//
//  DummyNetworkManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import Foundation

final class DummyNetworkManager: NetworkManagerType {
    
    var requester: RequesterType
    
    init() {
        requester = DummyRequester()
    }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String : String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        return nil
    }
}
