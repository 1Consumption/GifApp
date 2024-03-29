//
//  SearchViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

struct SearchViewModelInput {
    
    let isEditing: Observable<String?> = Observable<String?>(value: nil)
    let textFieldChanged: Debounce<String?> = Debounce<String?>(value: nil, wait: 0.5)
    let searchFire: Observable<String?> = Observable<String?>(value: nil)
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
    
    init(useCase: AutoCompleteUseCaseType = AutoCompleteUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.isEditing.bind {
            guard let text = $0 else { return }
            output.searchTextFieldIsEmpty.value = text.isEmpty
        }.store(in: &bag)
        
        input.textFieldChanged.bind { [weak self] in
            guard let text = $0 else { return }
            self?.useCase.retrieveAutoComplete(keyword: text,
                                               completionHandler: { [weak self] result in
                                                switch result {
                                                case .success(let model):
                                                    self?.autoCompletes = model.data
                                                    output.autoCompleteDelivered.fire()
                                                case .failure(let error):
                                                    output.errorDelivered.value = error
                                                }
                                               })
        }.store(in: &bag)
        
        input.searchFire.bind {
            output.searchFired.value = $0
        }.store(in: &bag)
        
        return output
    }
    
    func keyword(of index: Int) -> String? {
        guard autoCompletes.count > index else { return nil }
        return autoCompletes[index].name
    }
}
