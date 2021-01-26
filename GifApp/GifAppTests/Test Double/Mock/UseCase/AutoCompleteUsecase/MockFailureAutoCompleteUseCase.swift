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

    func retrieveAutoComplete(keyword: String, completionHandler: @escaping (Result<AutoCompleteResponse, UseCaseError>) -> Void) {
        callCount += 1
        self.keyword = keyword
        completionHandler(.failure(.decodeError))
    }
    
    func verify(keyword: String?) {
        XCTAssertEqual(keyword, self.keyword)
        XCTAssertEqual(callCount, 1)
    }
}
