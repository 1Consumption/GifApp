//
//  DummyFavoriteManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/26.
//

@testable import GifApp
import XCTest

final class DummyFavoriteManager: FavoriteManagerType {
    
    func changeFavoriteState(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) { }
    
    func retrieveGifInfo(completionHandler: @escaping (Result<[GifInfo], FavoriteManagerError>) -> Void) { }
}
