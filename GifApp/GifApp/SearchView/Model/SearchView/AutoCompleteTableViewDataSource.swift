//
//  AutoCompleteTableViewDataSource.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import UIKit

final class AutoCompleteTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: SearchViewModel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.autoCompletes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteTableViewCell.identifier) as? AutoCompleteTableViewCell else { return UITableViewCell() }
        
        cell.wordLabel.text = viewModel.autoCompletes[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
}
