//
//  SearchResultViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

struct SearchResultViewModelInput {
    let nextPageRequest: Observable<String?> = Observable<String?>(value: nil)
    let showDetail: Observable<String?> = Observable<String?>(value: nil)
}

struct SearchResultViewModelOutput {
    let nextPageDelivered: Observable<[IndexPath]> = Observable<[IndexPath]>(value: [])
    let errorDelivered: Observable<UseCaseError?> = Observable<UseCaseError?>(value: nil)
    let showDetailFired: Observable<String> = Observable<String>(value: "")
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
                                          failureHandler: {
                                            output.errorDelivered.value = $0
                                          },
                                          successHandler: { [weak self] response in
                                            guard let count = self?.gifInfoArray.count else { return }
                                            
                                            let startIndex = count
                                            let endIndex = startIndex + response.data.count
                                            
                                            output.nextPageDelivered.value = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                                            
                                            self?.gifInfoArray.append(contentsOf: response.data)
                                          })
        }.store(in: &bag)
        
        input.showDetail.bind {
            guard let id = $0 else { return }
            output.showDetailFired.value = id
        }.store(in: &bag)
        
        return output
    }
}
