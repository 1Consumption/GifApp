//
//  DummySearchResultUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import Foundation

final class DummySearchResultUseCase: SearchResultUseCaseType {
    
    func retrieveGifInfo(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void) {
    }
}
