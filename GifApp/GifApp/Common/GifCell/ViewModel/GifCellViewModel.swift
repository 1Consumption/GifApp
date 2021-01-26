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
                                                             completionHandler: { result in
                                                                switch result {
                                                                case .success(let data):
                                                                    guard let data = data else { return }
                                                                    output.gifDelivered.value = data
                                                                case .failure:
                                                                    output.errorDelivered.fire()
                                                                }
                                                             })
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.bind { [weak self] in
            guard let gifInfo = self?.gifInfo else { return }
            self?.favoriteManager.changeFavoriteState(with: gifInfo,
                                                      completionHandler: { result in
                                                        switch result {
                                                        case .success(let factor):
                                                            if factor == true {
                                                                output.favoriteConfirm.fire()
                                                            } else {
                                                                output.favoriteCanceled.fire()
                                                            }
                                                        case .failure(let error):
                                                            output.favoriteErrorDelivered.value = error
                                                        }
                                                      })
        }.store(in: &bag)
        
        return output
    }
}
