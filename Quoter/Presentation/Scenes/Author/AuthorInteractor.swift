//
//  AuthorInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit

protocol AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol? { get set }
    var authorNetworkWorker: AuthorNetworkWorkerProtocol? { get set }
    
    var tableViewItems: [SectionProtocol] { get set }
    var authorID: String? { get set }
    var categoryName: String? { get set }
    var dataSourceInfo: AuthorDataSourceInfoProtocol? { get set }
    
    func showView()
    func hideView()
    
    func getDataSourceInfo()
    func getTableViewItems()
    
    //MARK: UITableview datasource and delegate functions
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, target: UIViewController)
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    //MARK: UICollectionview datasource and delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class AuthorInteractor: AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol?
    var authorNetworkWorker: AuthorNetworkWorkerProtocol?
    
    var tableViewItems: [SectionProtocol] = []
    var authorID: String?
    var categoryName: String?
    var dataSourceInfo: AuthorDataSourceInfoProtocol?
    
    func showView() {
        UIView.animateKeyframes(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.presenter?.showView()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.presenter?.showContent()
            }
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.presenter?.hideContent()
        } completion: { didFinish in
            if didFinish {
                UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.hideView()
                } completion: { didFinish in
                    if didFinish {
                        self.presenter?.dismissView()
                    }
                }
            }
        }
    }
    
    func getDataSourceInfo() {
//        Task.init {  [weak self] in
//            guard let self = self else { return }
//            let dataSourceInfo = try await self.authorNetworkWorker?.getDataSourceInfo()
//            let content = try await self.authorNetworkWorker.
//            await MainActor.run {
//                self.dataSourceInfo = dataSourceInfo
//
//            }
//        }
    }
    
    func getTableViewItems() {
        guard let authorID = authorID else {
            return
        }
        guard let categoryName = categoryName else {
            return
        }
        Task.init { [weak self] in
            guard let self = self else { return }
            let content = try await self.authorNetworkWorker?.getSections(authorID: authorID, categoryName: categoryName)
            try await MainActor.run {
                self.tableViewItems = content ?? []
                
            }
        }
    }
}

extension AuthorInteractor {
    func numberOfSections(in tableView: UITableView) -> Int {
        AuthorCellsManager.shared.everyCellObjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        AuthorCellsManager.shared.everyCellObjects[indexPath.section][indexPath.row].rowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        AuthorCellsManager.shared.everyCellObjects[section].first!.sectionNameOfCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        AuthorCellsManager.shared.everyCellObjects[indexPath.section][indexPath.row].dequeCell(tableView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, target: UIViewController) {
        AuthorCellsManager.shared.everyCellObjects[indexPath.section][indexPath.row].willDisplay(cell)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
}

extension AuthorInteractor {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 50)
    }
}
