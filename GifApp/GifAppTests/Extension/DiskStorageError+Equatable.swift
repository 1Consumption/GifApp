//
//  DiskStorageError+Equatable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/23.
//

@testable import GifApp
import Foundation

extension DiskStorageError: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.canNotFoundDocumentDirectory, .canNotFoundDocumentDirectory):
            return true
        case (.canNotCreateStorageDirectory(let left), .canNotCreateStorageDirectory(let right)):
            return left == right
        case (.storeError(let left), .storeError(let right)):
            return left == right
        case (.removeError(let left), .removeError(let right)):
            return left == right
        case (.canNotLoadFileList(let left), .canNotLoadFileList(let right)):
            return left == right
        default:
            return false
        }
    }
}
