//
//  UseCaseError+Equatable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import Foundation

extension UseCaseError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.decodeError, .decodeError):
            return true
        case (.networkError(let left), .networkError(let right)):
            return left == right
        default:
            return false
        }
    }
}

