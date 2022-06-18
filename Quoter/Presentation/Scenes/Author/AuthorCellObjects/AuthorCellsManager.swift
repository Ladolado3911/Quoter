//
//  CellStrategyProtocol.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit

protocol CellProtocol {
    var sectionNameOfCell: String { get }
    var cellIdentifier: String { get }
    var rowHeight: CGFloat { get }
    var innerCollectionView: UICollectionView { get }

    func configureInnerCollectionView(target: UIViewController)
    
    //MARK: functions on cell
    func registerCell(_ tableView: UITableView)
    func dequeCell(_ tableView: UITableView) -> UITableViewCell
    func willDisplay(_ cell: UITableViewCell)
}

protocol CellsManagerProtocol {
    var everyCellObjects: [[CellProtocol]] { get }
}

final class AuthorCellsManager: CellsManagerProtocol {
    
    static let shared = AuthorCellsManager()
    
    private init() {}
    
    var everyCellObjects: [[CellProtocol]] = [
        [AuthorQuotesForSectionCellObject()],
        [OtherAuthorsForSectionCellObject()],
        
    ]
    
    
}
