//
//  SearchResultViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class SearchResultViewController: UIViewController {

    static let identifier: String = "SearchResultViewController"
    var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = keyword
        navigationItem.backButtonTitle = ""
    }
}
