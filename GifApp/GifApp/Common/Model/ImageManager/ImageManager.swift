//
//  ImageManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

protocol ImageManagerType {
    func retrieveImage(from url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable?
}

final class ImageManager: ImageManagerType {
    
    static let shared: ImageManager = ImageManager()
    
    private let networkManager: NetworkManagerType
    private let memoryStorage: MemoryCacheStorage<Data>
    private var diskStorage: DiskStorageType?
    private let diskQueue: DispatchQueue = DispatchQueue(label: "com.diskQueue", attributes: .concurrent)
    
    init(networkManager: NetworkManagerType = NetworkManager(requester: ImageRequester()), expireTime: ExpireTime = .minute(1), diskStorage: DiskStorageType? = try? DiskStorage(directoryName: "imageFolder")) {
        self.networkManager = networkManager
        self.memoryStorage = MemoryCacheStorage<Data>(expireTime: expireTime)
        self.diskStorage = diskStorage
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cleanUpExpired),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    func retrieveImage(from url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        if memoryStorage.isCached(url) {
            let data = memoryStorage.object(for: url)
            completionHandler(.success(data))
        } else if diskStorage?.isStored(url) == true {
            diskQueue.async { [weak self] in
                guard let data = self?.diskStorage?.data(for: url) else { return }
                self?.memoryStorage.insert(data, for: url)
                completionHandler(.success(data))
            }
        } else {
            return loadImage(from: url, completionHandler: completionHandler)
        }
        
        return nil
    }
    
    private func loadImage(from url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        let task = networkManager.loadData(with: URL(string: url),
                                           method: .get,
                                           headers: nil,
                                           completionHandler: { [weak self] result in
                                            let result = result.flatMap { data -> Result<Data?, NetworkError> in
                                                self?.diskQueue.async { [weak self] in
                                                    do {
                                                        try self?.diskStorage?.store(data, for: url)
                                                    } catch let error as DiskStorageError {
                                                        print(error.message)
                                                    } catch {
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                                
                                                self?.memoryStorage.insert(data, for: url)
                                                return .success(data)
                                            }
                                            completionHandler(result)
                                           })
        
        let cancellable = Cancellable { task?.cancel() }
        
        return cancellable
    }
    
    @objc private func cleanUpExpired() {
        memoryStorage.removeExpireAll()
    }
}
