//
//  FavoriteManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/24.
//

import Foundation

enum FavoriteManagerError: Error {
    case diskStorageError(DiskStorageError)
    case encodeError
}

final class FavoriteManager {
    
    private var diskStorage: DiskStorageType?
    
    init(diskStorage: DiskStorageType? = try? DiskStorage(directoryName: "Favorite")) {
        self.diskStorage = diskStorage
    }
    
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
    }
}
