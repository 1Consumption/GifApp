//
//  DetailCollectionViewDataSource.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/27.
//

import UIKit

final class DetailCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var gifInfoList: [GifInfo]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifInfoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let gifInfo = gifInfoList?[indexPath.item] else { return cell }
        
        let detailCellViewModel = DetailCellViewModel(gifInfo: gifInfo)
        cell.bind(with: detailCellViewModel)
        
        return cell
    }
}
