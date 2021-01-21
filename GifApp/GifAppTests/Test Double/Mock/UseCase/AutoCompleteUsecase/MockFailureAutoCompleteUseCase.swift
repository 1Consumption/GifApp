//
//  MockFailureAutoCompleteUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class MockFailureAutoCompleteUseCase: AutoCompleteUseCaseType {

    private var keyword: String?
    private var callCount: Int = 0

    func retrieveAutoComplete(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (AutoCompleteResponse) -> Void) {
        callCount += 1
        self.keyword = keyword
        failureHandler(.decodeError)
    }
    
    func verify(keyword: String?) {
        XCTAssertEqual(keyword, self.keyword)
        XCTAssertEqual(callCount, 1)
    }
}
