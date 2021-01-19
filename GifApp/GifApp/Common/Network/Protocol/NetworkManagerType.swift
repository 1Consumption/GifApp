//
//  NetworkManagerType.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

protocol NetworkManagerType {
    
    var requester: RequesterType { get }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String: String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
