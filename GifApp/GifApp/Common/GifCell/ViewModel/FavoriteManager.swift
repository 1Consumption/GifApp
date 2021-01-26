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
    func changeFavoriteState(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void)
    func retrieveGifInfo(completionHandler: @escaping (Result<[GifInfo], FavoriteManagerError>) -> Void)
}

final class FavoriteManager: FavoriteManagerType {
    
    private var diskStorage: DiskStorageType?
    private let diskQueue: DispatchQueue = DispatchQueue(label: "com.favoriteManager")
    
    init(diskStorage: DiskStorageType? = try? DiskStorage(directoryName: "Favorite")) {
        self.diskStorage = diskStorage
    }
    
    func changeFavoriteState(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        if diskStorage?.isStored(gifInfo.id) == true {
            remove(with: gifInfo, completionHandler: completionHandler)
        } else {
            store(with: gifInfo, completionHandler: completionHandler)
        }
    }
    
    func retrieveGifInfo(completionHandler: @escaping (Result<[GifInfo], FavoriteManagerError>) -> Void) {
        diskQueue.async { [weak self] in
            do {
                guard let dataList = try self?.diskStorage?.itemsInDirectory() else { return }
                let result = dataList.compactMap { try? JSONDecoder().decode(GifInfo.self, from: $0) }
                completionHandler(.success(result))
            } catch let error as DiskStorageError {
                completionHandler(.failure(.diskStorageError(error)))
            } catch {
                completionHandler(.failure(.unknownError(error)))
            }
        }
    }
    
    private func store(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gifInfo)
            try diskStorage?.store(data, for: gifInfo.id)
            completionHandler(.success(true))
        } catch let error as DiskStorageError {
            completionHandler(.failure(.diskStorageError(error)))
        } catch {
            completionHandler(.failure(.unknownError(error)))
        }
    }
    
    private func remove(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        do {
            try diskStorage?.remove(for: gifInfo.id)
            completionHandler(.success(false))
        } catch let error as DiskStorageError {
            completionHandler(.failure(.diskStorageError(error)))
        } catch {
            completionHandler(.failure(.unknownError(error)))
        }
    }
}
