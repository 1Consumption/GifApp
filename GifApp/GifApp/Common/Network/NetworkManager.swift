//
//  NetworkManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

final class NetworkManager: NetworkManagerType {
    private(set) var requester: RequesterType
    
    init(requester: RequesterType = DefaultRequester()) {
        self.requester = requester
    }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String: String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let url = url else {
            completionHandler(.failure(.emptyURL))
            return nil
        }
        
        let urlRequest = makeURLRequest(with: url, method: method, headers: headers)
        
        let task = requester.loadData(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.requestError(description: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.nonHTTPResponseError))
                return
            }
            
            completionHandler(.success(data!))
        }
        
        task.resume()
        
        return task
    }
    
    private func makeURLRequest(with url: URL, method: HTTPMethod, headers: [String: String]?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        headers?.forEach { field, value in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        return urlRequest
    }
}
