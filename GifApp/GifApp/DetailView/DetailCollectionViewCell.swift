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
    
    func bind(with viewModel: DetailCellViewModel) {

    }
}
