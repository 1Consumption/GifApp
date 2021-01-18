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
        navigationItem.title = "Search"
    }
    
    private func setUpTrandingCollectionView() {
        trandingCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        trandingCollectionView.dataSource = self
        trandingCollectionView.delegate = self
        trandingCollectionView.delaysContentTouches = false
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GifInfo.stub.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else { return UICollectionViewCell() }
        let url = URL(string: GifInfo.stub[indexPath.item].images.original.url)!
        let data = try! Data(contentsOf: url)
        cell.gifImageView.image = UIImage(data: data)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(Double(GifInfo.stub[indexPath.item].images.original.height)!)
        let width = CGFloat(Double(GifInfo.stub[indexPath.item].images.original.width)!)
        
        return CGSize(width: view.frame.width / 2, height: height * view.frame.width / 2 / width)
    }
}
