//
//  GifCellViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

struct GifCellViewModelInput {
    
    let loadGif: Observable<Void> = Observable<Void>(value: ())
    let favoriteStateShouldChange: Observable<Void> = Observable<Void>(value: ())
}

struct GifCellViewModelOutput {
    
    let gifDelivered: Observable<Data> = Observable<Data>(value: Data())
    let favoriteConfirm: Observable<Void> = Observable<Void>(value: ())
    let favoriteCanceled: Observable<Void> = Observable<Void>(value: ())
    let errorDelivered: Observable<Void> = Observable<Void>(value: ())
    let favoriteErrorDelivered: Observable<FavoriteManagerError?> = Observable<FavoriteManagerError?>(value: nil)
}

final class GifCellViewModel: ViewModelType {
    
    private var bag: CancellableBag = CancellableBag()
    private var gifInfo: GifInfo
    private var request: Cancellable?
    private let imageManager: ImageManagerType
    private let favoriteManager: FavoriteManagerType
    
    init(gifInfo: GifInfo, imageManager: ImageManagerType = ImageManager.shared, favoriteManager: FavoriteManagerType = FavoriteManager()) {
        self.gifInfo = gifInfo
        self.imageManager = imageManager
        self.favoriteManager = favoriteManager
    }
    
    func transform(_ input: GifCellViewModelInput) -> GifCellViewModelOutput {
        let output = GifCellViewModelOutput()
        
        input.loadGif.bind { [weak self] in
            guard let url = self?.gifInfo.images.fixedWidth.url else { return }
            self?.request = self?.imageManager.retrieveImage(from: url,
                                                             failureHandler: { output.errorDelivered.fire()
                                                             },
                                                             dataHandler: {
                                                                guard let data = $0 else { return }
                                                                output.gifDelivered.value = data
                                                             })
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.bind { [weak self] in
            guard let gifInfo = self?.gifInfo else { return }
            self?.favoriteManager.changeFavoriteState(with: gifInfo,
                                                      failureHandler: {
                                                        output.favoriteErrorDelivered.value = $0
                                                      }, successHandler: {
                                                        if $0 == true {
                                                            output.favoriteConfirm.fire()
                                                        } else {
                                                            output.favoriteCanceled.fire()
                                                        }
                                                      })
        }.store(in: &bag)
        
        return output
    }
}
