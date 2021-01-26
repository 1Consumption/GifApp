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

struct TrendingGifViewModelOutput {
    
    let gifInfoDelivered: Observable<Void> = Observable<Void>(value: ())
    let errorDelivered: Observable<UseCaseError?> = Observable<UseCaseError?>(value: nil)
}

final class TrendingGifViewModel: ViewModelType, GifManagerType {
    
    private let useCase: TrendingGifUseCaseType
    private var bag: CancellableBag = CancellableBag()
    private(set) var gifInfoArray: [GifInfo] = [GifInfo]()
    
    init(useCase: TrendingGifUseCaseType = TrendingGifUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: TrendingGifViewModelInput) -> TrendingGifViewModelOutput {
        let output = TrendingGifViewModelOutput()
        
        input.loadGifInfo.bind { [weak self] in
            self?.useCase.retrieveGifInfo { [weak self] result in
                switch result {
                case .success(let model):
                    self?.gifInfoArray = model.data
                    output.gifInfoDelivered.fire()
                case .failure(let error):
                    output.errorDelivered.value = error
                }
            }
        }.store(in: &bag)
        
        return output
    }
}
