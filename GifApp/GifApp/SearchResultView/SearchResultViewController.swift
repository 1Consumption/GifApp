//
//  SearchResultViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    
    static let identifier: String = "SearchResultViewController"
    var keyword: String?
    
    private var bag: CancellableBag = CancellableBag()
    private let searchResultViewModel: SearchResultViewModel = SearchResultViewModel()
    private let searchResultViewModelInput: SearchResultViewModelInput = SearchResultViewModelInput()
    private let searchResultCollectionViewDataSource: GifCollectionViewDataSource = GifCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = keyword
        navigationItem.backButtonTitle = ""
        setUpSearchResultCollectionView()
        searchResultViewModelInput.nextPageRequest.value = keyword
    }
    
    private func setUpSearchResultCollectionView() {
        searchResultCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        searchResultCollectionViewDataSource.viewModel = searchResultViewModel
        searchResultCollectionView.dataSource = searchResultCollectionViewDataSource
        searchResultCollectionView.delaysContentTouches = false
        searchResultCollectionView.delegate = self
        if let layout = searchResultCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        bindWithSearchResultViewModel()
    }
    
    private func bindWithSearchResultViewModel() {
        let output = searchResultViewModel.transform(searchResultViewModelInput)
        
        output.nextPageDelivered.bind { range in
            DispatchQueue.main.async { [weak self] in
                self?.searchResultCollectionView.insertItems(at: range)
            }
        }.store(in: &bag)
        
        output.showDetailFired.bind { [weak self] in
            guard let detailViewController = self?.storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
            detailViewController.id = $0
            
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }.store(in: &bag)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width) / 2
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let datasource = collectionView.dataSource as? GifCollectionViewDataSource else { return }
        searchResultViewModelInput.showDetail.value = datasource.gifInfo(of: indexPath.item)?.id
    }
}

extension SearchResultViewController: PinterestLayoutDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let dataSource = collectionView.dataSource as? GifCollectionViewDataSource else { return .zero }
        guard let strWidth = dataSource.gifInfo(of: indexPath.item)?.images.original.width,
              let strHeight = dataSource.gifInfo(of: indexPath.item)?.images.original.height,
              let width = Double(strWidth),
              let height = Double(strHeight)
        else { return .zero }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndexPathItem < indexPath.item + 20 else { return }
        
        searchResultViewModelInput.nextPageRequest.value = keyword
    }
}
