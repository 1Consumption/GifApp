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
    
    init(gifInfo: GifInfo, detailUseCase: DetailUseCaseType) {
        self.gifInfo = gifInfo
        self.detailUseCase = detailUseCase
    }
    
    func transform(_ input: DetailCellViewModelInput) -> DetailCellViewModelOutput {
        let ouput = DetailCellViewModelOutput()
        
        return ouput
    }
}
