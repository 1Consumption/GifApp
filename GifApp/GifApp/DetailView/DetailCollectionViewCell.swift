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
    @IBAction func favoriteButtonPushed(_ sender: Any) {
        viewModelInput.favoriteStateShouldChange.fire()
    }
    
    private var gesture: UITapGestureRecognizer!
    private let viewModelInput: DetailCellViewModelInput = DetailCellViewModelInput()
    private var viewModel: DetailCellViewModel?
    private var bag: CancellableBag = CancellableBag()
    
    func bind(with viewModel: DetailCellViewModel) {
        self.viewModel = viewModel
    
        gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        gesture.numberOfTapsRequired = 2
        gifImageView.addGestureRecognizer(gesture)
        
        let output = viewModel.transform(viewModelInput)
        
        output.gifDelivered.bind { data in
            DispatchQueue.main.async { [weak self] in
                self?.gifImageView.animate(withGIFData: data)
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        output.userInfoDelivered.bind { [weak self] userInfo in
            self?.userNameLabel.text = userInfo?.userName
            self?.displayNameLabel.text = userInfo?.displayName
        }.store(in: &bag)
        
        output.userImageDelivered.bind { data in
            DispatchQueue.main.async { [weak self] in
                self?.userImageView.image = UIImage(data: data)
            }
        }.store(in: &bag)
        
        output.favoriteConfirm.bind {
            DispatchQueue.main.async { [weak self] in
                self?.favoriteButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            }
        }.store(in: &bag)
        
        output.favoriteCanceled.bind {
            DispatchQueue.main.async { [weak self] in
                self?.favoriteButton.setImage(UIImage(named: "heartWhite"), for: .normal)
            }
        }.store(in: &bag)
        
        viewModelInput.isFavorite.fire()
        viewModelInput.loadUserInfo.fire()
        viewModelInput.loadGif.fire()
    }
    
    @objc private func doubleTapped() {
        viewModelInput.favoriteStateShouldChange.fire()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.stopAnimatingGIF()
        gifImageView.image = nil
        userImageView.image = UIImage(systemName: "person.circle.fill")
        favoriteButton.setImage(UIImage(named: "heartWhite"), for: .normal)
        viewModel = nil
        bag.removeAll()
        activityIndicator.startAnimating()
        gifImageView.removeGestureRecognizer(gesture)
    }
}
