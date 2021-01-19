//
//  NetworkError.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

enum NetworkError: Error {
    case emptyURL
    case requestError(description: String)
    case nonHTTPResponseError
    case invalidHTTPStatusCode(with: Int)
    case emptyData
    
    var message: String {
        switch self {
        case .emptyURL:
            return "empty URL"
        case .requestError(let errorDescription):
            return "request error with \(errorDescription)"
        case .nonHTTPResponseError:
            return "response is not HTTP response"
        case .invalidHTTPStatusCode(let code):
            return "invalid HTTP status code: \(code)"
        case .emptyData:
            return "empty data"
        }
    }
}
