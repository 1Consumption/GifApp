//
//  SearchViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

final class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTrandingCollectionView()
        trendingGifViewModelIntput.loadGifInfo.fire()
    }
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    private let trendingGifViewModel: TrendingGifViewModel = TrendingGifViewModel()
    private let trendingGifViewModelIntput: TrendingGifViewModelInput = TrendingGifViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Search"
    }
    
    private func setUpTrandingCollectionView() {
        trendingCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        trendingCollectionView.delaysContentTouches = false
        if let layout = trendingCollectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        bindWithTrendingGifViewModel()
    }
    
    private func bindWithTrendingGifViewModel() {
        let output = trendingGifViewModel.transform(trendingGifViewModelIntput)
        
        output.gifInfoDelivered.bind { gifInfo in
            DispatchQueue.main.async { [weak self] in
                self?.trendingCollectionView.reloadData()
            }
        }.store(in: &bag)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingGifViewModel.gifInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else { return UICollectionViewCell() }

        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width) / 2
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = collectionView.numberOfItems(inSection: 0) - 1
    
        guard lastItem < indexPath.item + 1 else { return }
        
        print("will display last cell")
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let height = Double(trendingGifViewModel.gifInfoArray[indexPath.item].images.original.height)!
        let width = Double(trendingGifViewModel.gifInfoArray[indexPath.item].images.original.width)!

        return CGSize(width: width, height: height)
    }
}
