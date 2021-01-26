//
//  MockFailureTrendingUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import Foundation

final class MockFailureTrendingUseCase: TrendingGifUseCaseType {
    
    func retrieveGifInfo(completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) {
        completionHandler(.failure(.decodeError))
    }
}
