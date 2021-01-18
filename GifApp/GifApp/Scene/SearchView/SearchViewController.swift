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
    }
    
    @IBOutlet weak var trandingCollectionView: UICollectionView!
    
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
        trandingCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        trandingCollectionView.dataSource = self
        trandingCollectionView.delegate = self
        trandingCollectionView.delaysContentTouches = false
        if let layout = trandingCollectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GifInfo.stub.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else { return UICollectionViewCell() }
        DispatchQueue.global().async {
            let url = URL(string: GifInfo.stub[indexPath.item].images.original.url)!
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                cell.gifImageView.image = UIImage(data: data)
            }
        }
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
        let height = CGFloat(Double(GifInfo.stub[indexPath.item].images.original.height)!)
        let width = CGFloat(Double(GifInfo.stub[indexPath.item].images.original.width)!)
        
        return CGSize(width: width, height: height)
    }
}
