//
//  MockFailureFavoriteManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/25.
//

@testable import GifApp
import XCTest

final class MockFailureFavoriteManager: FavoriteManagerType {
    
    private var gifInfo: GifInfo?
    private var changeFavoriteStateCallCount: Int = 0
    private var retrieveGifInfoCallCount: Int = 0
    private let error: FavoriteManagerError
    
    init(error: FavoriteManagerError = .encodeError) {
        self.error = error
    }
    
    func changeFavoriteState(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        changeFavoriteStateCallCount += 1
        self.gifInfo = gifInfo
        completionHandler(.failure(error))
    }
    
    func retrieveGifInfo(completionHandler: @escaping (Result<[GifInfo], FavoriteManagerError>) -> Void) {
        retrieveGifInfoCallCount += 1
        completionHandler(.failure(error))
    }
    
    func verifyChangeFavoriteState(gifInfo: GifInfo, callCount: Int = 1) {
        XCTAssertEqual(self.gifInfo, gifInfo)
        XCTAssertEqual(changeFavoriteStateCallCount, callCount)
    }
    
    func verifyRetrieveGifInfo(callCount: Int = 1) {
        XCTAssertEqual(retrieveGifInfoCallCount, callCount)
    }
}
