//
//  DummyAutoCompleteUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import Foundation

final class DummyAutoCompleteUseCase: AutoCompleteUseCaseType {
    
    func retrieveAutoComplete(keyword: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (AutoCompleteResponse) -> Void) {
    }
}
