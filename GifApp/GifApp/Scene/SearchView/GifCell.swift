//
//  GifCell.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

final class GifCell: UICollectionViewCell {
    
    static let identifier: String = "GifCell"

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
