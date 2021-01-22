//
//  UseCaseError.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

enum UseCaseError: Error {
    
    case networkError(with: NetworkError)
    case decodeError
    case endOfPage
    
    var message: String {
        switch self {
        case .networkError(let error):
            return error.message
        case .decodeError:
            return "decode error"
        case .endOfPage:
            return "end of page"
        }
    }
}
