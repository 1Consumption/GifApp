//
//  FavoriteManagerError+Equatable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import Foundation

extension FavoriteManagerError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.diskStorageError(let left), .diskStorageError(let right)):
            return left == right
        default:
            return false
        }
    }
}
