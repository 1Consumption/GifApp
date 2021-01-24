//
//  GifCellViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

struct GifCellViewModelInput {
    
    let loadGif: Observable<Void> = Observable<Void>(value: ())
}

struct GifCellViewModelOutput {
    
    let gifDelivered: Observable<Data> = Observable<Data>(value: Data())
    let errorDelivered: Observable<Void> = Observable<Void>(value: ())
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
                                                             failureHandler: { output.errorDelivered.fire() },
                                                             dataHandler: {
                                                                guard let data = $0 else { return }
                                                                output.gifDelivered.value = data
                                                             })
        }.store(in: &bag)
        
        return output
    }
}
