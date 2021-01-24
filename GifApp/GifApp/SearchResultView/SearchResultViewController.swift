//
//  SearchResultViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var searchTextField: PaddingTextField!
    @IBAction func searchButtonTouched(_ sender: Any) {
        searchViewModelInput.searchFire.value = searchTextField.text
    }
    
    static let identifier: String = "SearchResultViewController"
    var keyword: String?
    
    private var bag: CancellableBag = CancellableBag()
    private let searchResultViewModel: SearchResultViewModel = SearchResultViewModel()
    private let searchResultViewModelInput: SearchResultViewModelInput = SearchResultViewModelInput()
    private let searchResultCollectionViewDataSource: GifCollectionViewDataSource = GifCollectionViewDataSource()
    private let searchViewModel: SearchViewModel = SearchViewModel()
    private let searchViewModelInput: SearchViewModelInput = SearchViewModelInput()
    private let autoCompleteTableViewDataSource: AutoCompleteTableViewDataSource = AutoCompleteTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = keyword
        navigationItem.backButtonTitle = ""
        setUpSearchResultCollectionView()
        setUpSearchView()
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
    
    private func setUpSearchView() {
        autoCompleteTableViewDataSource.viewModel = searchViewModel
        autoCompleteTableView.dataSource = autoCompleteTableViewDataSource
        autoCompleteTableView.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldEditChanged(_:)), for: .editingChanged)
        searchTextField.delegate = self
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

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
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

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSouce = tableView.dataSource as? AutoCompleteTableViewDataSource else { return }
        searchViewModelInput.searchFire.value = dataSouce.keyword(of: indexPath.item)
    }
}

extension SearchResultViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchViewModelInput.searchFire.value = textField.text
        return true
    }
}
