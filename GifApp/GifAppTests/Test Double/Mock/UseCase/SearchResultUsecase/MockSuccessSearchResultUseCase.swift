//
//  MockSuccessSearchResultUseCase.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import XCTest

final class MockSuccessSearchResultUseCase: SearchResultUseCaseType {
    
    private var keyword: String?
    private var callCount: Int = 0
    
    func retrieveGifInfo(keyword: String, completionHandler: @escaping (Result<GifInfoResponse, UseCaseError>) -> Void) {
        callCount += 1
        self.keyword = keyword
        
        let model = GifInfoResponse(data:
                                        [GifInfo(id: "1",
                                                 username: "",
                                                 source: "",
                                                 images: GifImages(original: GifImage(height: "",
                                                                                      width: "",
                                                                                      url: ""),
                                                                   fixedWidth: GifImage(height: "",
                                                                                        width: "",
                                                                                        url: "")))],
                                       pagination: Pagination(totalCount: 1,
                                                              count: 1,
                                                              offset: 0))
        
        completionHandler(.success(model))
    }
    
    func verify(keyword: String?, callCount: Int = 1) {
        XCTAssertEqual(self.keyword, keyword)
        XCTAssertEqual(self.callCount, callCount)
    }
}
