//
//  SearchResultUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

protocol SearchResultUseCaseType {
    
    func retrieveGifInfo(keyword: String, completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void)
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
    
    func retrieveGifInfo(keyword: String, completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) {
        guard !isLoading else {
            completionHandler(.failure(.duplicatedRequest))
            return
        }
        
        isLoading = true
        
        guard !isEndOfPage else {
            completionHandler(.failure(.endOfPage))
            return
        }
        
        let url = EndPoint(urlInfomation: .search(keyword: keyword, offset: offset)).url
        
        retrieveModel(with: url,
                      method: .get,
                      headers: nil,
                      completionHandler: { [weak self] result in
                        if let response = try? result.get() {
                            let pagination = response.pagination
                            self?.isEndOfPage = pagination.offset + pagination.count >= pagination.totalCount
                            self?.offset = pagination.offset + pagination.count
                            self?.isLoading = false
                        }
                        
                        completionHandler(result)
                      })
    }
}
