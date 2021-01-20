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
    private var bag: CancellableBag = CancellableBag()
    
    func testViewModelOutputGifDelivered() {
        let expectation = XCTestExpectation(description: "gif delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        
        let imageManager = MockSuccessImageManager()
        let viewModel = GifCellViewModel(gifURL: "test", imageManager: imageManager)
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
        
        imageManager.verify(url: "test")
    }
    
    func testViewModelCancellable() {
        let expectation = XCTestExpectation(description: "cancelled")
        
        let imageManager = MockSuccessCancellableImageManager { expectation.fulfill() }
        
        var viewModel: GifCellViewModel? = GifCellViewModel(gifURL: "test", imageManager: imageManager)
        
        let _ = viewModel?.transform(input)
        
        input.loadGif.fire()
        
        viewModel = nil
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testViewModelOutputErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = MockFailureImageManager()
        let viewModel = GifCellViewModel(gifURL: "test", imageManager: imageManager)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
        
        imageManager.verify(url: "test")
    }
}
