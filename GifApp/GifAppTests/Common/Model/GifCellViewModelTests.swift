//
//  GifCellViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class GifCellViewModelTests: XCTestCase {
 
    private let input: GifCellViewModelInput = GifCellViewModelInput()
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")))
    private var bag: CancellableBag = CancellableBag()
    private var viewModel: GifCellViewModel!
    
    func testViewModelOutputGifDelivered() {
        let expectation = XCTestExpectation(description: "gif delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        
        let imageManager = MockSuccessImageManager()
        viewModel = GifCellViewModel(gifInfo: gifInfo, imageManager: imageManager)
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind { _ in
            imageManager.verify(url: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testViewModelCancellable() {
        let expectation = XCTestExpectation(description: "cancelled")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = MockSuccessCancellableImageManager { expectation.fulfill() }
        
        viewModel = GifCellViewModel(gifInfo: gifInfo, imageManager: imageManager)
        
        let _ = viewModel?.transform(input)
        
        input.loadGif.fire()
        
        viewModel = nil
    }
    
    func testViewModelOutputErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = MockFailureImageManager()
        viewModel = GifCellViewModel(gifInfo: gifInfo, imageManager: imageManager)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind {
            imageManager.verify(url: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
}
