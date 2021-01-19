//
//  TrendingGifViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

struct TrendingGifViewModelInput {
    let loadGifInfo: Observable<Void> = Observable<Void>(value: ())
}

struct TrendingGifViewModelOtuput {
    let gifInfoDelivered: Observable<Void> = Observable<Void>(value: ())
    let errorDelivered: Observable<UseCaseError?> = Observable<UseCaseError?>(value: nil)
}

final class TrendingGifViewModel: ViewModelType {
    
    private let useCase: TrendingGifUseCaseType
    private var bag: CancellableBag = CancellableBag()
    var gifInfoArray: [GifInfo] = [GifInfo]()
    
    init(useCase: TrendingGifUseCaseType = TrendingGifUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: TrendingGifViewModelInput) -> TrendingGifViewModelOtuput {
        let output = TrendingGifViewModelOtuput()
        
        input.loadGifInfo.bind { [weak self] in
            self?.useCase.retrieveGifInfo(failureHandler: { error in
                output.errorDelivered.value = error
            },
            successHandler: { [weak self] gifInfoResponse in
                self?.gifInfoArray = gifInfoResponse.data
                output.gifInfoDelivered.fire()
            })
        }.store(in: &bag)
        
        return output
    }
    
    func gifInfo(of index: Int) -> GifInfo? {
        guard gifInfoArray.count > index else { return nil }
        return gifInfoArray[index]
    }
}
