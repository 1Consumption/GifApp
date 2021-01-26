//
//  DummyTrendingUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/26.
//

@testable import GifApp
import Foundation

final class DummyTrendingUseCase: TrendingGifUseCaseType {
    
    func retrieveGifInfo(completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) { }
}
