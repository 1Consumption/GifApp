//
//  SearchResultViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

struct SearchResultViewModelInput {
    
    let nextPageRequest: Observable<String?> = Observable<String?>(value: nil)
    let showDetail: Observable<IndexPath?> = Observable<IndexPath?>(value: nil)
}

struct SearchResultViewModelOutput {
    
    let nextPageDelivered: Observable<[IndexPath]> = Observable<[IndexPath]>(value: [])
    let errorDelivered: Observable<UseCaseError?> = Observable<UseCaseError?>(value: nil)
    let showDetailFired: Observable<IndexPath?> = Observable<IndexPath?>(value: nil)
}

final class SearchResultViewModel: ViewModelType, GifManagerType {
    
    private let useCase: SearchResultUseCaseType
    private var bag: CancellableBag = CancellableBag()
    private(set) var gifInfoArray: [GifInfo] = []
    
    init(useCase: SearchResultUseCaseType = SearchResultUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: SearchResultViewModelInput) -> SearchResultViewModelOutput {
        let output = SearchResultViewModelOutput()
        
        input.nextPageRequest.bind { [weak self] in
            guard let keyword = $0 else { return }
            self?.useCase.retrieveGifInfo(keyword: keyword,
                                          completionHandler: { [weak self] result in
                                            switch result {
                                            case .success(let model):
                                                guard let count = self?.gifInfoArray.count else { return }
                                                
                                                let startIndex = count
                                                let endIndex = startIndex + model.data.count
                                                
                                                self?.gifInfoArray.append(contentsOf: model.data)
                                                
                                                output.nextPageDelivered.value = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                                            case .failure(let error):
                                                output.errorDelivered.value = error
                                            }
                                          })
        }.store(in: &bag)
        
        input.showDetail.bind {
            output.showDetailFired.value = $0
        }.store(in: &bag)
        
        return output
    }
}
