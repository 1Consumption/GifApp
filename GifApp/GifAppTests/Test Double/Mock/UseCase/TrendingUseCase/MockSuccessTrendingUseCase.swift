//
//  MockSuccessTrendingUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import Foundation

struct MockSuccessTrendingUseCase: TrendingGifUseCaseType {
    
    func retrieveGifInfo(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void) {
        let model = GifInfoResponse(data: [GifInfo(id: "1",
                                                   username: "test",
                                                   source: "test",
                                                   images: GifImages(original: GifImage(height: "", width: "", url: ""), fixedWidth: GifImage(height: "", width: "", url: "")))],
                                    pagination: Pagination(totalCount: 0, count: 0, offset: 0))
        
        successHandler(model)
    }
}
