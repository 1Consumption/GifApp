//
//  FavoriteViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/25.
//

import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    private let dataSoruce: GifCollectionViewDataSource = GifCollectionViewDataSource()
    private let favoriteCollectionViewModel: FavoriteCollectionViewModel = FavoriteCollectionViewModel()
    private let favoriteCollectionViewModelInput: FavoriteCollectionViewModelInput = FavoriteCollectionViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
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
        dataSoruce.viewModel = favoriteCollectionViewModel
        favoriteCollectionView.dataSource = dataSoruce
        if let layout = favoriteCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        bindWithFavoriteCollectionViewModel()
    }
    
    private func bindWithFavoriteCollectionViewModel() {
        let output = favoriteCollectionViewModel.transform(favoriteCollectionViewModelInput)
        
        output.favoriteListDelivered.bind {
            DispatchQueue.main.async { [weak self] in
                self?.favoriteCollectionView.reloadData()
            }
        }.store(in: &bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteCollectionViewModelInput.loadFavoriteList.fire()
    }
}

extension FavoriteViewController: PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let dataSource = collectionView.dataSource as? GifCollectionViewDataSource else { return .zero }
        guard let strWidth = dataSource.gifInfo(of: indexPath.item)?.images.original.width,
              let strHeight = dataSource.gifInfo(of: indexPath.item)?.images.original.height,
              let width = Double(strWidth),
              let height = Double(strHeight)
        else { return .zero }
        
        return CGSize(width: width, height: height)
    }
}
