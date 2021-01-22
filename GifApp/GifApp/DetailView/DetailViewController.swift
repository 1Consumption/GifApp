//
//  DetailViewController.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class DetailViewController: UIViewController {
    
    static let identifier: String = "DetailViewController"

    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(id)
        navigationItem.title = "GIF"
        navigationItem.backButtonTitle = ""
    }
}
