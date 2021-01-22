//
//  TrendingGifCollectionViewDataSource.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

final class TrendingGifCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: TrendingGifViewModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.gifInfoArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else { return UICollectionViewCell() }
        
        guard let model = viewModel?.gifInfoArray[indexPath.item] else { return cell }
        
        cell.bind(with: model.images.fixedWidth.url)
        
        return cell
    }
    
    func gifInfo(of index: Int) -> GifInfo? {
        return viewModel?.gifInfo(of: index)
    }
}
