//
//  ImageManager.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import SwiftGifOrigin
import UIKit

final class ImageManager {
    
    private let networkManager: NetworkManagerType
    private let memoryStorage: MemoryCacheStorage<UIImage>
    
    init(networkManager: NetworkManagerType = NetworkManager(requester: ImageRequester()), expireTime: ExpireTime = .minute(1)) {
        self.networkManager = networkManager
        self.memoryStorage = MemoryCacheStorage<UIImage>(expireTime: expireTime)
    }
    
    func retrieveImage(from url: String, failureHandler: @escaping (NetworkError) -> Void, imageHandler: @escaping (UIImage?) -> Void) {
        if memoryStorage.isCached(url) {
            imageHandler(memoryStorage.object(for: url))
        } else {
            networkManager.loadData(with: URL(string: url),
                                    method: .get,
                                    headers: nil,
                                    completionHandler: { [weak self] result in
                                        switch result {
                                        case .success(let data):
                                            let gifImage = UIImage.gif(data: data)
                                            imageHandler(gifImage)
                                            self?.memoryStorage.insert(gifImage, for: url)
                                        case .failure(_):
                                            break
                                        }
                                    })
        }
    }
}
