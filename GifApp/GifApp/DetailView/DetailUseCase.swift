//
//  DetailUseCase.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import Foundation


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
        
    }
    
    func retrieveIsFavorite(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        
    }
}
