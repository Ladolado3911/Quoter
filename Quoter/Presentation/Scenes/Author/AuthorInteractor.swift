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
        AuthorCellsManager.shared.everyCellObjects[indexPath.section][indexPath.row].willDisplay(cell, target: target)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }

}
