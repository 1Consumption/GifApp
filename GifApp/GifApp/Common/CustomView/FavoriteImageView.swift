//
//  FavoriteImageView.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/25.
//

import UIKit

final class FavoriteImageView: UIImageView {
    
    private let heart: UIImage? = UIImage(named: "heart")
    private let heartFill: UIImage? = UIImage(named: "heart.fill")
    
    func favorite() {
        image = heartFill
        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options: .allowUserInteraction,
                                                       animations: { [weak self] in
                                                        self?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                                       },
                                                       completion: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2,
                                                       delay: 0.5,
                                                       options: .allowUserInteraction,
                                                       animations: { [weak self] in
                                                        self?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                                       },
                                                       completion: { [weak self] _ in
                                                        self?.isHidden = true
                                                       })
    }
    
    func favoriteCancel() {
        isHidden = false
        transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options: .allowUserInteraction,
                                                       animations: { [weak self] in
                                                        self?.image = self?.heart
                                                       },
                                                       completion: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25,
                                                       delay: 0.5,
                                                       options: .allowUserInteraction,
                                                       animations: { [weak self] in
                                                        self?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                                       },
                                                       completion: { [weak self] _ in
                                                        self?.isHidden = true
                                                       })
    }
}
