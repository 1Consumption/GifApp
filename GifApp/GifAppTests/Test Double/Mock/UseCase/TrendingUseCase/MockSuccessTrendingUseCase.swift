//
//  MockSuccessTrendingUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import Foundation

final class MockSuccessTrendingUseCase: TrendingGifUseCaseType {
    
    func retrieveGifInfo(completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) {
        let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                   username: "test",
                                                   source: "test",
                                                   images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")),
                                                   user: User(avatarUrl: "", username: "", displayName: ""))],
                                    pagination: Pagination(totalCount: 0, count: 0, offset: 0))
        
        completionHandler(.success(model))
    }
}
