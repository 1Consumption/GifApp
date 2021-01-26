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
    let favoriteCancel: Observable<[IndexPath]> = Observable<[IndexPath]>(value: [])
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
            self?.favoriteManager.retrieveGifInfo { result in
                switch result {
                case .success(let model):
                    guard self?.gifInfoArray != model else { return }
                    self?.gifInfoArray = model
                    output.favoriteListDelivered.fire()
                case .failure(let error):
                    output.favoriteErrorDelivered.value = error
                }
            }
        }.store(in: &bag)
        
        input.showDetail.bind { [weak self] in
            guard let index = $0?.item else { return }
            output.showDetailFired.value = self?.gifInfo(of: index)
        }.store(in: &bag)
        
        NotificationCenter.default.addObserver(forName: .FavoriteCancel,
                                               object: nil,
                                               queue: nil,
                                               using: { [weak self] notification in
                                                guard let gifInfo = notification.userInfo?["gifInfo"] as? GifInfo else { return }
                                                guard let index = self?.gifInfoArray.firstIndex(of: gifInfo) else { return }
                                                
                                                self?.gifInfoArray.remove(at: index)
                                                output.favoriteCancel.value = [IndexPath(item: index, section: 0)]
                                               })
        
        return output
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
