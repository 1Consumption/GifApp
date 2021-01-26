//
//  TrendingGifUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

protocol TrendingGifUseCaseType {
    
    func retrieveGifInfo(completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void)
}

final class TrendingGifUseCase: TrendingGifUseCaseType, RemoteDataDecodeType {
    
    typealias T = GifInfoResponse
    
    var networkManager: NetworkManagerType
    private var prevTask: URLSessionDataTask?
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveGifInfo(completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) {
        let url = EndPoint(urlInfomation: .trending).url
        
        prevTask = retrieveModel(with: url,
                                 method: .get,
                                 headers: nil,
                                 completionHandler: completionHandler)
    }
}
