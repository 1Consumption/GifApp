//
//  NetworkError+Equatable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import Foundation

extension NetworkError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.emptyURL, .emptyURL):
            return true
        default:
            return false
        }
    }
}
