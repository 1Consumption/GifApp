//
//  AutoCompleteUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

protocol AutoCompleteUseCaseType {
    
    func retrieveAutoComplete(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (AutoCompleteResponse) -> Void)
}

struct AutoCompleteUseCase: RemoteDataDecodeType, AutoCompleteUseCaseType {

    typealias T = AutoCompleteResponse
    
    var networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveAutoComplete(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) {
        let url = EndPoint(urlInfomation: .autoComplete(keyword: keyword)).url
        
        retrieveModel(with: url,
                      method: .get,
                      headers: nil,
                      failureHandler: failureHandler, successHandler: successHandler)
    }
}
