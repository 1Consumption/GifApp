//
//  ImageManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import SwiftGifOrigin
import UIKit

protocol ImageManagerType {
    func retrieveImage(from url: String, failureHandler: @escaping (NetworkError) -> Void, imageHandler: @escaping (UIImage?) -> Void) -> Cancellable?
}

final class ImageManager: ImageManagerType {
    
    static let shared: ImageManager = ImageManager()
    
    private let networkManager: NetworkManagerType
    private let memoryStorage: MemoryCacheStorage<UIImage>
    private let imageQueue: DispatchQueue = DispatchQueue(label: "com.imageQueue", attributes: .concurrent)
    
    init(networkManager: NetworkManagerType = NetworkManager(requester: ImageRequester()), expireTime: ExpireTime = .minute(1)) {
        self.networkManager = networkManager
        self.memoryStorage = MemoryCacheStorage<UIImage>(expireTime: expireTime)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cleanUpExpired),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    func retrieveImage(from url: String, failureHandler: @escaping (NetworkError) -> Void, imageHandler: @escaping (UIImage?) -> Void) -> Cancellable? {
        guard memoryStorage.isCached(url) else {
            return loadImage(from: url, fairureHandler: failureHandler, imageHandler: imageHandler)
        }
        
        guard let image = memoryStorage.object(for: url) else {
            return loadImage(from: url, fairureHandler: failureHandler, imageHandler: imageHandler)
        }
        
        imageHandler(image)
        
        return nil
    }
    
    private func loadImage(from url: String, fairureHandler: @escaping (NetworkError) -> Void, imageHandler: @escaping (UIImage?) -> Void) -> Cancellable {
        let task = networkManager.loadData(with: URL(string: url),
                                           method: .get,
                                           headers: nil,
                                           completionHandler: { [weak self] result in
                                            switch result {
                                            case .success(let data):
                                                self?.imageQueue.async {
                                                    let gifImage = UIImage.gif(data: data)
                                                    imageHandler(gifImage)
                                                    self?.memoryStorage.insert(gifImage, for: url)
                                                }
                                            case .failure(let error):
                                                fairureHandler(error)
                                            }
                                           })
        
        let cancellable = Cancellable { task?.cancel() }
        
        return cancellable
    }
    
    @objc private func cleanUpExpired() {
        memoryStorage.removeExpireAll()
    }
}
