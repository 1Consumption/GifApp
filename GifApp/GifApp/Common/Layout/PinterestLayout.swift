//
//  PinterestLayout.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

protocol PinterestLayoutDelegate: class {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

final class PinterestLayout: UICollectionViewLayout {
  
  weak var delegate: PinterestLayoutDelegate?
  
  private var numberOfColumns = 2
  private var spacing: CGFloat = 3
  
  private var cache = [UICollectionViewLayoutAttributes]()
  
  private var contentHeight: CGFloat = 0
  
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return 0 }
    
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    cache.removeAll()
    contentHeight = 0
    guard cache.isEmpty, let collectionView = collectionView else { return }
    
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    
    (0..<numberOfColumns).forEach {
      xOffset.append(CGFloat($0) * columnWidth)
    }
    
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    (0..<collectionView.numberOfItems(inSection: 0)).forEach {
      let indexPath = IndexPath(item: $0, section: 0)
      
      guard let photoSize = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) else { return }
      
      var height = photoSize.height * (columnWidth - spacing * 2) / photoSize.width
      height += spacing * 2
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      
      var insetFrame: CGRect = .zero
      
      if ($0 + 1) % 2 == 1 {
        insetFrame = frame.inset(by: UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: spacing))
      } else {
        insetFrame = frame.inset(by: UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: 0))
      }
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] += height
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    cache.forEach {
      guard $0.frame.intersects(rect) else { return }
      visibleLayoutAttributes.append($0)
    }
    
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}
