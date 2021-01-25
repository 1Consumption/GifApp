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

final class FavoriteCollectionViewModel: ViewModelType {
    
    private var favoriteManager: FavoriteManagerType
    private var bag: CancellableBag = CancellableBag()
    private(set) var gifInfoList: [GifInfo] = [GifInfo]()
    
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
                guard self?.gifInfoList != $0 else { return }
                self?.gifInfoList = $0
                output.favoriteListDelivered.fire()
            })
        }.store(in: &bag)
        
        return output
    }
}
