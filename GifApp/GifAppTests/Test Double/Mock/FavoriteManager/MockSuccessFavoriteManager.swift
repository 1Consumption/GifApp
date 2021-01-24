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
    private var callCount: Int = 0
    private var store: [String: GifInfo] = [String: GifInfo]()
    
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        callCount += 1
        self.gifInfo = gifInfo
        
        if store[gifInfo.id] == nil {
            store[gifInfo.id] = gifInfo
            successHandler(true)
        } else {
            store[gifInfo.id] = nil
            successHandler(false)
        }
    }
    
    func verify(gifInfo: GifInfo, callCount: Int = 1) {
        XCTAssertEqual(self.gifInfo, gifInfo)
        XCTAssertEqual(self.callCount, callCount)
    }
}
