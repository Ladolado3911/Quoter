//
//  OtherAuthorsForSectionCellObject.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit


class OtherAuthorsForSectionCellObject: CellProtocol {
    
    var sectionNameOfCell: String = "Other authors"
    
    var cellIdentifier: String {
        OtherAuthorsForSectionCell.cellIdentifier
    }
    
    class OtherAuthorsForSectionCell: UITableViewCell {
        
        static let cellIdentifier: String = String(describing: OtherAuthorsForSectionCellObject.OtherAuthorsForSectionCell.self)
        
        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = .blue
        }
        
        func buildSubviews() {
            
        }
        
        func buildConstraints() {
            
        }
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(OtherAuthorsForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OtherAuthorsForSectionCell
    }
    
    func willDisplay(_ cell: UITableViewCell) {
        
    }
}

