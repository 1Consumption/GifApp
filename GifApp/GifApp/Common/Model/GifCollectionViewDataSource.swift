//
//  GifCollectionViewDataSource.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

final class GifCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: GifManagerType?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.gifInfoArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.identifier, for: indexPath) as? GifCell else { return UICollectionViewCell() }
        
        guard let gifInfo = viewModel?.gifInfoArray[indexPath.item] else { return cell }
        
        cell.bind(with: gifInfo)
        
        return cell
    }
}
