//
//  TrendingGifUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

protocol TrendingGifUseCaseType {
    
    func retrieveGifInfo(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void)
}

final class TrendingGifUseCase: TrendingGifUseCaseType, RemoteDataDecodeType {
    
    typealias T = GifInfoResponse
    
    var networkManager: NetworkManagerType
    private var prevTask: URLSessionDataTask?
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveGifInfo(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) {
        let url = EndPoint(urlInfomation: .trending).url
        
        prevTask = retrieveModel(with: url, method: .get, headers: nil, failureHandler: failureHandler, successHandler: successHandler)
    }
}
