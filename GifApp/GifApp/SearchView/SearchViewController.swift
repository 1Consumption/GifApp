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
    @IBOutlet weak var searchTextField: PaddingTextField!
    @IBAction func searchButtonTouched(_ sender: Any) {
        searchViewModelInput.searchFire.value = searchTextField.text
    }
    
    private let trendingGifCollectionViewDataSource: GifCollectionViewDataSource = GifCollectionViewDataSource()
    private let trendingGifViewModel: TrendingGifViewModel = TrendingGifViewModel()
    private let trendingGifViewModelIntput: TrendingGifViewModelInput = TrendingGifViewModelInput()
    private let autoCompleteTableViewDataSource: AutoCompleteTableViewDataSource = AutoCompleteTableViewDataSource()
    private let searchViewModel: SearchViewModel = SearchViewModel()
    private let searchViewModelInput: SearchViewModelInput = SearchViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTrandingCollectionView()
        setUpSearchView()
        searchTextField.addTarget(self, action: #selector(textFieldEditChanged(_:)), for: .editingChanged)
        trendingGifViewModelIntput.loadGifInfo.fire()
    }
    
    private func setUpNavigationBar() {
        navigationItem.backButtonTitle = ""
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
    
    private func setUpSearchView() {
        autoCompleteTableViewDataSource.viewModel = searchViewModel
        autoCompleteTableView.dataSource = autoCompleteTableViewDataSource
        autoCompleteTableView.delegate = self
        bindWithSearchViewModel()
    }
    
    private func bindWithSearchViewModel() {
        let output = searchViewModel.transform(searchViewModelInput)
        
        output.searchTextFieldIsEmpty.bind { searchTextFieldIsEmpty in
            DispatchQueue.main.async { [weak self] in
                self?.autoCompleteTableView.isHidden = searchTextFieldIsEmpty
            }
        }.store(in: &bag)
        
        output.autoCompleteDelivered.bind {
            DispatchQueue.main.async { [weak self] in
                self?.autoCompleteTableView.reloadData()
            }
        }.store(in: &bag)
        
        output.searchFired.bind { [weak self] in
            guard let searchResultViewController = self?.storyboard?.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { return }
            searchResultViewController.keyword = $0
            self?.navigationController?.pushViewController(searchResultViewController, animated: true)
        }.store(in: &bag)
    }
    
    @objc private func textFieldEditChanged(_ textField: UITextField) {
        searchViewModelInput.isEditing.value = textField.text
        searchViewModelInput.textFieldChanged.value = textField.text
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
}

extension SearchViewController: PinterestLayoutDelegate {
    
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
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSouce = tableView.dataSource as? AutoCompleteTableViewDataSource else { return }
        searchViewModelInput.searchFire.value = dataSouce.keyword(of: indexPath.item)
    }
}
