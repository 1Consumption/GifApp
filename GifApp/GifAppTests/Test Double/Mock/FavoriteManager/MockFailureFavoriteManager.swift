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
    private var callCount: Int = 0
    
    func changeFavoriteState(with gifInfo: GifInfo, failureHandler: @escaping (FavoriteManagerError) -> Void, successHandler: @escaping (Bool) -> Void) {
        callCount += 1
        self.gifInfo = gifInfo
        failureHandler(.encodeError)
    }
    
    func verify(gifInfo: GifInfo, callCount: Int = 1) {
        XCTAssertEqual(self.gifInfo, gifInfo)
        XCTAssertEqual(self.callCount, callCount)
    }
}
