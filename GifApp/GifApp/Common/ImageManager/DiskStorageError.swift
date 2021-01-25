//
//  DiskStorageError.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/24.
//

import Foundation

enum DiskStorageError: Error {
    
    case canNotFoundDocumentDirectory
    case canNotCreateStorageDirectory(path: String)
    case storeError(path: String)
    case removeError(path: String)
    case canNotLoadFileList(path: String)
    
    var message: String {
        switch self {
        case .canNotFoundDocumentDirectory:
            return "can't found document directory"
        case .canNotCreateStorageDirectory(let path):
            return "can't create storage directory in \(path)"
        case .storeError(let path):
            return "can't store value into \(path)"
        case .removeError(let path):
            return "can't remove value located at \(path)"
        case .canNotLoadFileList(let path):
            return "can't load file list in \(path)"
        }
    }
}
