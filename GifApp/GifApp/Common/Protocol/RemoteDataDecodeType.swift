//
//  RemoteDataDecodeType.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

protocol RemoteDataDecodeType {
    
    associatedtype T: Decodable
    
    var networkManager: NetworkManagerType { get }
    
    @discardableResult
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, completionHandler: @escaping (Result<T, UseCaseError>) -> Void) -> URLSessionDataTask?
}

extension RemoteDataDecodeType {
    
    @discardableResult
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, completionHandler: @escaping (Result<T, UseCaseError>) -> Void) -> URLSessionDataTask? {
        let task = networkManager.loadData(with: url, method: method, headers: headers) { result in
            let result = result
                .flatMapError { .failure(UseCaseError.networkError(with: $0)) }
                .flatMap { data -> Result<T, UseCaseError> in
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let model = try decoder.decode(T.self, from: data)
                        return .success(model)
                    } catch {
                        return .failure(UseCaseError.decodeError)
                    }
                }
            
            completionHandler(result)
        }
        
        return task
    }
}
