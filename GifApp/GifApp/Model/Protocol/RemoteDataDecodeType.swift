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
    
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) -> URLSessionDataTask?
}

extension RemoteDataDecodeType {
    
    func retrieveModel(with url: URL?, method: HTTPMethod, headers: [String: String]?, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) -> URLSessionDataTask? {
        let task = networkManager.loadData(with: url, method: method, headers: headers) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try! decoder.decode(T.self, from: data)
                successHandler(model)
                
                break
            case .failure(_):
                break
            }
        }
        
        return task
    }
}
