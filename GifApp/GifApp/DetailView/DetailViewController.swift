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
    private var isLayouted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationItem()
        setUpDetailCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !isLayouted else { return }
        
        guard let indexPath = indexPath else { return }
        
        detailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        isLayouted = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailCollectionView.reloadData()
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
