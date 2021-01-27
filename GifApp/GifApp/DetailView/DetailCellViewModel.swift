//
//  DetailCellViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import Foundation

struct DetailCellViewModelInput {
    
    let loadGif: Observable<Void> = Observable<Void>(value: ())
    let isFavorite: Observable<Void> = Observable<Void>(value: ())
    let favoriteStateShouldChange: Observable<Void> = Observable<Void>(value: ())
}

struct DetailCellViewModelOutput {
    
    let gifDelivered: Observable<Data> = Observable<Data>(value: Data())
    let isFavoriteDelivered: Observable<Bool> = Observable<Bool>(value: false)
    let favoriteConfirm: Observable<Void> = Observable<Void>(value: ())
    let favoriteCanceled: Observable<Void> = Observable<Void>(value: ())
    let imageErrorDelivered: Observable<Void> = Observable<Void>(value: ())
    let favoriteErrorDelivered: Observable<FavoriteManagerError?> = Observable<FavoriteManagerError?>(value: nil)
}

final class DetailCellViewModel: ViewModelType {
    
    private let gifInfo: GifInfo
    private let detailUseCase: DetailUseCaseType
    private var bag: CancellableBag = CancellableBag()
    
    init(gifInfo: GifInfo, detailUseCase: DetailUseCaseType = DetailUseCase()) {
        self.gifInfo = gifInfo
        self.detailUseCase = detailUseCase
    }
    
    func transform(_ input: DetailCellViewModelInput) -> DetailCellViewModelOutput {
        let output = DetailCellViewModelOutput()
        
        input.loadGif.bind { [weak self] in
            guard let url = self?.gifInfo.images.original.url else { return }
            guard var bag = self?.bag else { return }
            self?.detailUseCase.retrieveImage(with: url,
                                        completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                guard let data = data else { return }
                                                output.gifDelivered.value = data
                                            case .failure:
                                                output.imageErrorDelivered.fire()
                                            }
                                        })?.store(in: &bag)
            self?.bag = bag
        }.store(in: &bag)
        
        input.isFavorite.bind { [weak self] in
            guard let gifInfo = self?.gifInfo else { return }
            self?.detailUseCase.retrieveIsFavorite(with: gifInfo,
                                                   completionHandler: { result in
                                                    switch result {
                                                    case .success(let isFavorite):
                                                        output.isFavoriteDelivered.value = isFavorite
                                                    case .failure(let error):
                                                        output.favoriteErrorDelivered.value = error
                                                    }
                                                   })
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.bind { [weak self] in
            guard let gifInfo = self?.gifInfo else { return }
            self?.detailUseCase.sendFavoriteStateChange(gifInfo: gifInfo,
                                                        completionHandler: { result in
                                                            switch result {
                                                            case .success(let isFavorite):
                                                                if isFavorite {
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
