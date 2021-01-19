//
//  GifCellViewModel.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import class UIKit.UIImage
import SwiftGifOrigin
import Foundation

struct GifCellViewModelInput {
    
    let loadGif: Observable<Void> = Observable<Void>(value: ())
}

struct GifCellViewModelOutput {
    
    let gifDelivered: Observable<UIImage?> = Observable<UIImage?>(value: nil)
}

final class GifCellViewModel: ViewModelType {
    
    private var bag: CancellableBag = CancellableBag()
    private var gifURL: String
    
    init(gifURL: String) {
        self.gifURL = gifURL
    }
    
    func transform(_ input: GifCellViewModelInput) -> GifCellViewModelOutput {
        let output = GifCellViewModelOutput()
        
        input.loadGif.bind {
            DispatchQueue.global().async { [weak self] in
                let data = try! Data(contentsOf: URL(string: self!.gifURL)!)
                output.gifDelivered.value = UIImage.gif(data: data)
            }
        }.store(in: &bag)
        
        return output
    }
}
