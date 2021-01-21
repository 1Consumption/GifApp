//
//  SearchViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

final class SearchViewController: UIViewController {
        
    @IBOutlet weak var trendingGifCollectionView: UICollectionView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    
    private let trendingGifCollectionViewDataSource: TrendingGifCollectionViewDataSource = TrendingGifCollectionViewDataSource()
    private let trendingGifViewModel: TrendingGifViewModel = TrendingGifViewModel()
    private let trendingGifViewModelIntput: TrendingGifViewModelInput = TrendingGifViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTrandingCollectionView()
        setUpAutoCompleteTableView()
        trendingGifViewModelIntput.loadGifInfo.fire()
    }
    
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
        trendingGifCollectionView.register(UINib(nibName: GifCell.identifier, bundle: .main), forCellWithReuseIdentifier: GifCell.identifier)
        trendingGifCollectionViewDataSource.viewModel = trendingGifViewModel
        trendingGifCollectionView.dataSource = trendingGifCollectionViewDataSource
        trendingGifCollectionView.delegate = self
        trendingGifCollectionView.delaysContentTouches = false
        if let layout = trendingGifCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        bindWithTrendingGifViewModel()
    }
    
    private func bindWithTrendingGifViewModel() {
        let output = trendingGifViewModel.transform(trendingGifViewModelIntput)
        
        output.gifInfoDelivered.bind { gifInfo in
            DispatchQueue.main.async { [weak self] in
                self?.trendingGifCollectionView.reloadData()
            }
        }.store(in: &bag)
    }
    
    private func setUpAutoCompleteTableView() {
        autoCompleteTableView.dataSource = self
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
        guard let dataSource = collectionView.dataSource as? TrendingGifCollectionViewDataSource else { return .zero }
        guard let strWidth = dataSource.gifInfo(of: indexPath.item)?.images.original.width,
              let strHeight = dataSource.gifInfo(of: indexPath.item)?.images.original.height,
              let width = Double(strWidth),
              let height = Double(strHeight)
        else { return .zero }
        
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteTableViewCell.identifier) as? AutoCompleteTableViewCell else { return UITableViewCell() }
        
        cell.wordLabel.text = "\(indexPath.row) cell"
        cell.selectionStyle = .none
        
        return cell
    }
}
