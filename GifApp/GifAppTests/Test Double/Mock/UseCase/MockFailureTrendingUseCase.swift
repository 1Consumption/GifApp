//
//  MockFailureTrendingUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import Foundation

struct MockFailureTrendingUseCase: TrendingGifUseCaseType {
    
    func retrieveGifInfo(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void) {
        failureHandler(.decodeError)
    }
}
