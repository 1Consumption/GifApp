//
//  DetailCollectionViewCell.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import Gifu
import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "DetailCollectionViewCell"
    
    @IBOutlet weak var gifImageView: GIFImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModelInput: DetailCellViewModelInput = DetailCellViewModelInput()
    private var viewModel: DetailCellViewModel?
    private var bag: CancellableBag = CancellableBag()
    
    func bind(with viewModel: DetailCellViewModel) {
        self.viewModel = viewModel
        
        let output = viewModel.transform(viewModelInput)
        
        output.gifDelivered.bind { data in
            DispatchQueue.main.async { [weak self] in
                self?.gifImageView.animate(withGIFData: data)
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        viewModelInput.loadGif.fire()
    }
}
