//
//  MockSuccessGifCellUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/27.
//

@testable import GifApp
import XCTest

final class MockSuccessGifCellUseCase: GifCellUseCaseType {
    
    private var retrieveImageUrl: String?
    private var retrieveImagCallCount: Int = 0
    
    private var sendFavoriteStateChangeGifInfo: GifInfo?
    private var sendFavoriteStateChangeCallCount: Int = 0
    
    private let isFavorite: Bool
    private let cancellableHandler: (() -> Void)?
    
    init(isFavorite: Bool = false, handler: (() -> Void)? = nil) {
        self.isFavorite = isFavorite
        self.cancellableHandler = handler
    }
    
    func retrieveImage(with url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        retrieveImageUrl = url
        retrieveImagCallCount += 1
        
        completionHandler(.success(Data()))
        
        return Cancellable { [weak self] in
            self?.cancellableHandler?()
        }
    }
    
    func sendFavoriteStateChange(gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        sendFavoriteStateChangeGifInfo = gifInfo
        sendFavoriteStateChangeCallCount += 1
        
        completionHandler(.success(!isFavorite))
    }
    
    func verifyRetrieveImage(url: String, callCount: Int = 1) {
        XCTAssertEqual(retrieveImageUrl, url)
        XCTAssertEqual(retrieveImagCallCount, callCount)
    }
    
    func verifysendFavoriteStateChange(gifInfo: GifInfo, callCount: Int = 1) {
        XCTAssertEqual(sendFavoriteStateChangeGifInfo, gifInfo)
        XCTAssertEqual(sendFavoriteStateChangeCallCount, callCount)
    }
}
