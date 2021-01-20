//
//  GifCellViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import class UIKit.UIImage
import SwiftGifOrigin
import Foundation

struct GifCellViewModelInput {
    
    let loadGif: Observable<Void> = Observable<Void>(value: ())
}

struct GifCellViewModelOutput {
    
    let gifDelivered: Observable<UIImage?> = Observable<UIImage?>(value: nil)
}

final class GifCellViewModel: ViewModelType {
    
    private var bag: CancellableBag = CancellableBag()
    private var gifURL: String
    private var request: Cancellable?
    private let imageManager: ImageManagerType
    
    init(gifURL: String, imageManager: ImageManagerType = ImageManager.shared) {
        self.gifURL = gifURL
        self.imageManager = imageManager
    }
    
    func transform(_ input: GifCellViewModelInput) -> GifCellViewModelOutput {
        let output = GifCellViewModelOutput()
        
        input.loadGif.bind { [weak self] in
            guard let url = self?.gifURL else { return }
            self?.request = self?.imageManager.retrieveImage(from: url,
                                              failureHandler: { print($0) },
                                              imageHandler: {
                                                output.gifDelivered.value = $0
                                              })
        }.store(in: &bag)
        
        return output
    }
}
