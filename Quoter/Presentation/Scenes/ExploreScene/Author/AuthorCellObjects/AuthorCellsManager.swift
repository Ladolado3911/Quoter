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
    var innerCollectionViewDataCount: Int { get }

    //MARK: functions on inner collection view cell
    func configureInnerCollectionView(target: UIViewController)
    func dequeInnerCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell
    func didSelectInnerCollectionViewCell()
    func sizeForInnerCollectionViewItemAt() -> CGSize
    func willDisplayInnerCollectionViewCell(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    //MARK: functions on cell
    func registerCell(_ tableView: UITableView)
    func dequeCell(_ tableView: UITableView) -> UITableViewCell
    func willDisplay(_ cell: UITableViewCell, networkWorker: CustomNetworkWorkerProtocol)
}

protocol CellsManagerProtocol {
    var dispatchGroup: DispatchGroup { get }
    var authorID: String? { get set }
    var authorName: String? { get set }
    var authorImageURLString: String? { get set }
    var authorDesc: String? { get set }
    var everyCellObjects: [[CellProtocol]] { get }
}

final class AuthorCellsManager: CellsManagerProtocol {
    
    static let shared = AuthorCellsManager()
    
    private init() {}
    
    var dispatchGroup: DispatchGroup = DispatchGroup()
    var authorID: String?
    var authorName: String?
    var authorImageURLString: String? 
    var authorDesc: String?
    
    var everyCellObjects: [[CellProtocol]] = [
        [AuthorQuotesForSectionCellObject()],
        //[OtherAuthorsForSectionCellObject()],
        
    ]
    
    
}
