//
//  GifCellUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import Foundation

final class GifCellUseCase {
    
    private let imageManager: ImageManagerType
    private let favoriteManager: FavoriteManagerType
    
    init(imageManager: ImageManagerType = ImageManager(), favoriteManager: FavoriteManagerType = FavoriteManager()) {
        self.imageManager = imageManager
        self.favoriteManager = favoriteManager
    }
    
    func retrieveImage(with url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        return imageManager.retrieveImage(from: url, completionHandler: completionHandler)
    }
    
    func sendFavoriteStateChange(gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        return favoriteManager.changeFavoriteState(with: gifInfo, completionHandler: completionHandler)
    }
}
