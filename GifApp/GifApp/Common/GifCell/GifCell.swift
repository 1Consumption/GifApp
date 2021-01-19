//
//  GifCell.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

final class GifCell: UICollectionViewCell {
    
    static let identifier: String = "GifCell"

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    private var gifCellViewModel: GifCellViewModel?
    private let gifCellViewModelInput: GifCellViewModelInput = GifCellViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonDoubleTapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    func bind(with url: String) {
        gifCellViewModel = GifCellViewModel(gifURL: url)
        
        let output = gifCellViewModel?.transform(gifCellViewModelInput).gifDelivered
        
        output?.bind { image in
            DispatchQueue.main.async { [weak self] in
                self?.gifImageView.image = image
            }
        }.store(in: &bag)
        
        gifCellViewModelInput.loadGif.fire()
    }
    
    @objc private func buttonDoubleTapped(_ sender: UITapGestureRecognizer) {
        print("double tapped")
    }
}
