//
//  ViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Search"
    }
}
