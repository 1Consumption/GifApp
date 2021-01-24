//
//  FavoriteViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/25.
//

import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpFavoriteCollectionView()
    }
    
    private func setUpNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Favorite"
    }
    
    private func setUpFavoriteCollectionView() {
        favoriteCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        favoriteCollectionView.delaysContentTouches = false
        if let layout = favoriteCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
}

extension FavoriteViewController: PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return .zero
    }
}
