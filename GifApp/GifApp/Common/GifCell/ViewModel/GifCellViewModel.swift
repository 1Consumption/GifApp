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
    private let useCase: GifCellUseCaseType
    
    init(gifInfo: GifInfo, gifCellUseCase: GifCellUseCaseType = GifCellUseCase()) {
        self.gifInfo = gifInfo
        self.useCase = gifCellUseCase
    }
    
    func transform(_ input: GifCellViewModelInput) -> GifCellViewModelOutput {
        let output = GifCellViewModelOutput()
        
        input.loadGif.bind { [weak self] in
            guard let url = self?.gifInfo.images.fixedWidth.url else { return }
            guard var bag = self?.bag else { return }
            self?.useCase.retrieveImage(with: url,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                guard let data = data else { return }
                                                output.gifDelivered.value = data
                                            case .failure:
                                                output.errorDelivered.fire()
                                            }
                                        })?.store(in: &bag)
            
            self?.bag = bag
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.bind { [weak self] in
            guard let gifInfo = self?.gifInfo else { return }
            self?.useCase.sendFavoriteStateChange(gifInfo: gifInfo,
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
