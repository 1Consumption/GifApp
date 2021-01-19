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
    
    func testViewModelOutputGifInfoDelivered() {
        let expectation = XCTestExpectation(description: "gif delivered")
        defer { wait(for: [expectation], timeout: 5.0) }
        
        let viewModel = GifCellViewModel(gifURL: "https://media1.giphy.com/media/JuB8b7G4oGsCNALT8I/giphy.gif?cid=cde2429b879azk7f5wj6dy8nqe6c05x0p655p2ayri1hhs6e&rid=giphy.gif")
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
}
