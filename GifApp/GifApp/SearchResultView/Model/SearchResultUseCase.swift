//
//  SearchResultUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

protocol SearchResultUseCaseType {
    
    func retrieveGifInfo(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void)
}

struct SearchResultUseCase: RemoteDataDecodeType {
    
    typealias T = GifInfoResponse
    
    var networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveGifInfo(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) {
        let url = EndPoint(urlInfomation: .search(keyword: keyword, offset: 0)).url
        
        retrieveModel(with: url,
                      method: .get,
                      headers: nil,
                      failureHandler: failureHandler,
                      successHandler: successHandler)
    }
}
