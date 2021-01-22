//
//  MockSuccessAutoCompleteUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class MockSuccessAutoCompleteUseCase: AutoCompleteUseCaseType {
    
    private var keyword: String?
    private var callCount: Int = 0

    func retrieveAutoComplete(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (AutoCompleteResponse) -> Void) {
        self.keyword = keyword
        callCount += 1
        successHandler(AutoCompleteResponse(data: [AutoComplete(name: "test")]))
    }
    
    func verify(keyword: String?) {
        XCTAssertEqual(keyword, self.keyword)
        XCTAssertEqual(callCount, 1)
    }
}
