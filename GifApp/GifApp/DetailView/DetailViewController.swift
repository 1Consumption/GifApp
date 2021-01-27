//
//  DetailViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class DetailViewController: UIViewController {
    
    static let identifier: String = "DetailViewController"

    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    var indexPath: IndexPath?
    var gifInfoList: [GifInfo]?
    
    private let dataSource: DetailCollectionViewDataSource = DetailCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationItem()
        setUpDetailCollectionView()
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "GIF"
        navigationItem.backButtonTitle = ""
    }
    
    private func setUpDetailCollectionView() {
        dataSource.gifInfoList = gifInfoList
        detailCollectionView.dataSource = dataSource
        detailCollectionView.delegate = self
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return detailCollectionView.bounds.size
    }
}
