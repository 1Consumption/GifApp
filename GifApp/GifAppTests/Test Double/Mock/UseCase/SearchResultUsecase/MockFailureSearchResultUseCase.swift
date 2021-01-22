//
//  MockFailureSearchResultUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class MockFailureSearchResultUseCase: SearchResultUseCaseType {
    
    private let error: UseCaseError
    private var keyword: String?
    private var callCount: Int = 0
    
    init(error: UseCaseError) {
        self.error = error
    }
    
    func retrieveGifInfo(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (GifInfoResponse) -> Void) {
        self.keyword = keyword
        self.callCount += 1
        
        failureHandler(error)
    }
    
    func verify(keyword: String?, callCount: Int = 1) {
        XCTAssertEqual(self.keyword, keyword)
        XCTAssertEqual(self.callCount, callCount)
    }
}
