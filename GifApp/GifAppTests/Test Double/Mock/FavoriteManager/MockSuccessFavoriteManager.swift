//
//  MockSuccessFavoriteManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/25.
//

@testable import GifApp
import XCTest

final class MockSuccessFavoriteManager: FavoriteManagerType {
    
    private var gifInfo: GifInfo?
    private var changeFavoriteStateCallCount: Int = 0
    private var retrieveGifInfoCallCount: Int = 0
    private var store: [String: GifInfo] = [String: GifInfo]()
    
    func changeFavoriteState(with gifInfo: GifInfo, completionHandler: @escaping (Result<Bool, FavoriteManagerError>) -> Void) {
        changeFavoriteStateCallCount += 1
        self.gifInfo = gifInfo
        
        if store[gifInfo.id] == nil {
            store[gifInfo.id] = gifInfo
            completionHandler(.success(true))
        } else {
            store[gifInfo.id] = nil
            completionHandler(.success(false))
        }
    }
    
    func retrieveGifInfo(completionHandler: @escaping (Result<[GifInfo], FavoriteManagerError>) -> Void) {
        retrieveGifInfoCallCount += 1
        completionHandler(.success(store.values.map { $0 }))
    }
    
    func verifyChangeFavoriteState(gifInfo: GifInfo, storageCount: Int, callCount: Int = 1) {
        XCTAssertEqual(self.gifInfo, gifInfo)
        XCTAssertEqual(self.store.count, storageCount)
        XCTAssertEqual(self.changeFavoriteStateCallCount, callCount)
    }
    
    func verifyRetrieveGifInfo(callCount: Int = 1) {
        XCTAssertEqual(retrieveGifInfoCallCount, callCount)
    }
}
