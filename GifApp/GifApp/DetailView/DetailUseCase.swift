//
//  DetailUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import Foundation

protocol DetailUseCaseType {
    
    func retrieveImage(with url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable?
    func sendFavoriteStateChange(gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void)
    func retrieveIsFavorite(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void)
}

final class DetailUseCase {
    
    private let imageManager: ImageManagerType
    private let favoriteManager: FavoriteManagerType
    
    init(imageManager: ImageManagerType = ImageManager.shared, favoriteManager: FavoriteManagerType = FavoriteManager()) {
        self.imageManager = imageManager
        self.favoriteManager = favoriteManager
    }
    
    func retrieveImage(with url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        return imageManager.retrieveImage(from: url, completionHandler: completionHandler)
    }
    
    func sendFavoriteStateChange(gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        favoriteManager.changeFavoriteState(with: gifInfo, completionHandler: completionHandler)
    }
    
    func retrieveIsFavorite(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        favoriteManager.retrieveGifInfo { result in
            let result = result.flatMap { gifInfoList -> Result<Bool, FavoriteManagerError> in
                return .success(gifInfoList.contains(gifInfo))
            }
            
            completionHandler(result)
        }
    }
}
