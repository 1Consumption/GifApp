//
//  AutoCompleteUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

protocol AutoCompleteUseCaseType {
    
    func retrieveAutoComplete(keyword: String, completionHandler: @escaping (Result<AutoCompleteResponse, UseCaseError>) -> Void)
}

final class AutoCompleteUseCase: RemoteDataDecodeType, AutoCompleteUseCaseType {

    typealias T = AutoCompleteResponse
    
    var networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveAutoComplete(keyword: String, completionHandler: @escaping (Result<AutoCompleteResponse, UseCaseError>) -> Void) {
        let url = EndPoint(urlInfomation: .autoComplete(keyword: keyword)).url
        
        retrieveModel(with: url,
                      method: .get,
                      headers: nil,
                      completionHandler: completionHandler)
    }
}
