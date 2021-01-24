//
//  ImageManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

protocol ImageManagerType {
    func retrieveImage(from url: String, failureHandler: @escaping () -> Void, dataHandler: @escaping (Data?) -> Void) -> Cancellable?
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
    
    func retrieveImage(from url: String, failureHandler: @escaping () -> Void, dataHandler: @escaping (Data?) -> Void) -> Cancellable? {
        if memoryStorage.isCached(url) {
            let data = memoryStorage.object(for: url)
            dataHandler(data)
        } else if diskStorage?.isStored(url) == true {
            diskQueue.async { [weak self] in
                guard let data = self?.diskStorage?.data(for: url) else { return }
                dataHandler(data)
            }
        } else {
            return loadImage(from: url, fairureHandler: failureHandler, imageHandler: dataHandler)
        }
        
        return nil
    }
    
    private func loadImage(from url: String, fairureHandler: @escaping () -> Void, imageHandler: @escaping (Data?) -> Void) -> Cancellable {
        let task = networkManager.loadData(with: URL(string: url),
                                           method: .get,
                                           headers: nil,
                                           completionHandler: { [weak self] result in
                                            switch result {
                                            case .success(let data):
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
                                                imageHandler(data)
                                            case .failure(_):
                                                fairureHandler()
                                            }
                                           })
        
        let cancellable = Cancellable { task?.cancel() }
        
        return cancellable
    }
    
    @objc private func cleanUpExpired() {
        memoryStorage.removeExpireAll()
    }
}
