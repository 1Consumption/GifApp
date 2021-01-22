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

final class SearchResultUseCase: RemoteDataDecodeType, SearchResultUseCaseType {
    
    typealias T = GifInfoResponse
    
    var networkManager: NetworkManagerType
    private var offset: Int = 0
    private var isEndOfPage: Bool = false
    private var isLoading: Bool = false
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveGifInfo(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (T) -> Void) {
        guard !isLoading else {
            failureHandler(.duplicatedRequest)
            return
        }
        
        isLoading = true
        
        guard !isEndOfPage else {
            failureHandler(.endOfPage)
            return
        }
        
        let url = EndPoint(urlInfomation: .search(keyword: keyword, offset: offset)).url

        retrieveModel(with: url,
                      method: .get,
                      headers: nil,
                      failureHandler: failureHandler,
                      successHandler: { [weak self] response in
                        let pagination = response.pagination
                        self?.isEndOfPage = (pagination.offset + 1) * pagination.count >= pagination.totalCount
                        self?.offset = pagination.offset + 1
                        self?.isLoading = false
                        
                        successHandler(response)
                      })
    }
}
