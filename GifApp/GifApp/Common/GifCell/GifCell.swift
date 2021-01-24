//
//  GifCell.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import Gifu
import UIKit

final class GifCell: UICollectionViewCell {
    
    static let identifier: String = "GifCell"

    @IBOutlet weak var favoriteImageView: FavoriteImageView!
    @IBOutlet weak var gifImageView: GIFImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var gifCellViewModel: GifCellViewModel?
    private let gifCellViewModelInput: GifCellViewModelInput = GifCellViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonDoubleTapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    func bind(with gifInfo: GifInfo) {
        gifCellViewModel = GifCellViewModel(gifInfo: gifInfo)
        
        let output = gifCellViewModel?.transform(gifCellViewModelInput)
        
        output?.gifDelivered.bind { data in
            DispatchQueue.main.async { [weak self] in
                self?.gifImageView.animate(withGIFData: data)
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        output?.errorDelivered.bind {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        gifCellViewModelInput.loadGif.fire()
    }
    
    @objc private func buttonDoubleTapped(_ sender: UITapGestureRecognizer) {
        print("double tapped")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.stopAnimatingGIF()
        gifImageView.image = nil
        gifCellViewModel = nil
        bag.removeAll()
        activityIndicator.startAnimating()
    }
}
