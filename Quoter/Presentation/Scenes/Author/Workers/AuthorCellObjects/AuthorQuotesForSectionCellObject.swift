//
//  AuthorQuotesForSectionCellObject.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit


class AuthorQuotesForSectionCellObject: CellProtocol {
    
    var cellIdentifier: String {
        AuthorQuotesForSectionCell.cellIdentifier
    }
    
    class AuthorQuotesForSectionCell: UITableViewCell {
        
        static let cellIdentifier: String = String(describing: AuthorQuotesForSectionCellObject.AuthorQuotesForSectionCell.self)
        
        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = .red
        }
        
        func buildSubviews() {
            
        }
        
        func buildConstraints() {
            
        }
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(AuthorQuotesForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AuthorQuotesForSectionCell
    }
}
