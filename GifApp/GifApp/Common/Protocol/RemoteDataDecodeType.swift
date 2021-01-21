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
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) -> URLSessionDataTask?
}

extension RemoteDataDecodeType {
    
    @discardableResult
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) -> URLSessionDataTask? {
        let task = networkManager.loadData(with: url, method: method, headers: headers) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let model = try decoder.decode(T.self, from: data)
                    successHandler(model)
                } catch {
                    failureHandler(.decodeError)
                }
                
                break
            case .failure(let error):
                failureHandler(.networkError(with: error))
            }
        }
        
        return task
    }
}
