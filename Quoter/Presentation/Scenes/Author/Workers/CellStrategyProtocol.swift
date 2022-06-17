//
//  CellStrategyProtocol.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit

protocol CellProtocol {
    var cellIdentifier: String { get }
    
    func registerCell(_ tableView: UITableView)
    func dequeCell(_ tableView: UITableView) -> UITableViewCell
}

final class AuthorCellsManager {
    
    static let shared = AuthorCellsManager()
    
    private init() {}
    
    let everyCellObjects: [CellProtocol] = [
        AuthorQuotesForSectionCellObject(),
        OtherAuthorsForSectionCellObject(),
        
    ]
    
    
}
