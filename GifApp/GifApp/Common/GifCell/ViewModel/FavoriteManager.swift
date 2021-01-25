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
    case unknownError(Error)
}

protocol FavoriteManagerType {
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void)
}

final class FavoriteManager: FavoriteManagerType {
    
    private var diskStorage: DiskStorageType?
    private let diskQueue: DispatchQueue = DispatchQueue(label: "com.favoriteManager")
    
    init(diskStorage: DiskStorageType? = try? DiskStorage(directoryName: "Favorite")) {
        self.diskStorage = diskStorage
    }
    
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        if diskStorage?.isStored(gifInfo.id) == true {
            remove(with: gifInfo, failureHandler: failureHandler, successHandler: successHandler)
        } else {
            store(with: gifInfo, failureHandler: failureHandler, successHandler: successHandler)
        }
    }
    
    func retrieveGifInfo(failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping ([GifInfo]) -> Void) {
        diskQueue.async { [weak self] in
            do {
                guard let dataList = try self?.diskStorage?.itemsInDirectory() else { return }
                let result = dataList.compactMap { try? JSONDecoder().decode(GifInfo.self, from: $0) }
                successHandler(result)
            } catch let error as DiskStorageError {
                failureHandler(.diskStorageError(error))
            } catch {
                failureHandler(.unknownError(error))
            }
        }
    }
    
    private func store(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gifInfo)
            try diskStorage?.store(data, for: gifInfo.id)
            successHandler(true)
        } catch let error as DiskStorageError {
            failureHandler(.diskStorageError(error))
        } catch {
            failureHandler(.encodeError)
        }
    }
    
    private func remove(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        do {
            try diskStorage?.remove(for: gifInfo.id)
            successHandler(false)
        } catch let error as DiskStorageError {
            failureHandler(.diskStorageError(error))
        } catch {
            failureHandler(.unknownError(error))
        }
    }
}
