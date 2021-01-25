//
//  FavoriteCollectionViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/25.
//

import Foundation

struct FavoriteCollectionViewModelInput {
    
    let loadFavoriteList: Observable<Void> = Observable<Void>(value: ())
    let showDetail: Observable<IndexPath?> = Observable<IndexPath?>(value: nil)
}

struct FavoriteCollectionViewModelOutput {
    
    let favoriteListDelivered: Observable<Void> = Observable<Void>(value: ())
    let favoriteErrorDelivered: Observable<FavoriteManagerError?> = Observable<FavoriteManagerError?>(value: nil)
    let showDetailFired: Observable<GifInfo?> = Observable<GifInfo?>(value: nil)
}

final class FavoriteCollectionViewModel: ViewModelType, GifManagerType {
    
    private var favoriteManager: FavoriteManagerType
    private var bag: CancellableBag = CancellableBag()
    private(set) var gifInfoArray: [GifInfo] = [GifInfo]()
    
    init(favoriteManager: FavoriteManagerType = FavoriteManager()) {
        self.favoriteManager = favoriteManager
    }
    
    func transform(_ input: FavoriteCollectionViewModelInput) -> FavoriteCollectionViewModelOutput {
        let output = FavoriteCollectionViewModelOutput()
        
        input.loadFavoriteList.bind { [weak self] in
            self?.favoriteManager.retrieveGifInfo(failureHandler: {
                output.favoriteErrorDelivered.value = $0
            },
            successHandler: { [weak self] in
                guard self?.gifInfoArray != $0 else { return }
                self?.gifInfoArray = $0
                output.favoriteListDelivered.fire()
            })
        }.store(in: &bag)
        
        input.showDetail.bind { [weak self] in
            guard let index = $0?.item else { return }
            output.showDetailFired.value = self?.gifInfo(of: index)
        }.store(in: &bag)
        
        return output
    }
}
