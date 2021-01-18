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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonDoubleTapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonDoubleTapped(_ sender: UITapGestureRecognizer) {
        print("double tapped")
    }
}
