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
    
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        changeFavoriteStateCallCount += 1
        self.gifInfo = gifInfo
        failureHandler(error)
    }
    
    func retrieveGifInfo(failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping ([GifInfo]) -> Void) {
        retrieveGifInfoCallCount += 1
        failureHandler(error)
    }
    
    func verifyChangeFavoriteState(gifInfo: GifInfo, callCount: Int = 1) {
        XCTAssertEqual(self.gifInfo, gifInfo)
        XCTAssertEqual(changeFavoriteStateCallCount, callCount)
    }
    
    func verifyRetrieveGifInfo(callCount: Int = 1) {
        XCTAssertEqual(retrieveGifInfoCallCount, callCount)
    }
}
