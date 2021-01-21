//
//  SearchViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

struct SearchViewModelInput {
    
    let isEditing: Observable<String> = Observable<String>(value: "")
    let textFieldChanged: Debounce<String> = Debounce<String>(value: "", wait: 0.5)
    let searchFire: Observable<String> = Observable<String>(value: "")
}

struct SearchViewModelOutput {
    
    let searchTextFieldIsEmpty: Observable<Bool> = Observable<Bool>(value: true)
    let autoCompleteDelivered: Observable<Void> = Observable<Void>(value: ())
    let errorDelivered: Observable<UseCaseError?> = Observable<UseCaseError?>(value: nil)
    let searchFired: Observable<String?> = Observable<String?>(value: "")
}

final class SearchViewModel: ViewModelType {
    
    private var useCase: AutoCompleteUseCaseType
    private var bag: CancellableBag = CancellableBag()
    private(set) var autoCompletes: [AutoComplete] = []
    
    init(useCase: AutoCompleteUseCaseType) {
        self.useCase = useCase
    }
 
    func transform(_ input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.isEditing.bind {
            output.searchTextFieldIsEmpty.value = $0.isEmpty
        }.store(in: &bag)
        
        input.textFieldChanged.bind { [weak self] in
            self?.useCase.retrieveAutoComplete(keyword: $0,
                                         failureHandler: {
                                            output.errorDelivered.value = $0
                                         },
                                         successHandler: { [weak self] response in
                                            self?.autoCompletes = response.data
                                            output.autoCompleteDelivered.fire()
                                         })
        }.store(in: &bag)
        return output
    }
}
