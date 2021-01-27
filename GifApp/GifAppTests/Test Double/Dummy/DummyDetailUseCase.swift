//
//  DummyDetailUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/27.
//

@testable import GifApp
import Foundation

final class DummyDetailUseCase: DetailUseCaseType {
    
    func retrieveImage(with url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? { return nil }
    
    func sendFavoriteStateChange(gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) { }
    func retrieveIsFavorite(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) { }
}
