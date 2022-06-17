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
    
    func showView()
    func hideView()
    
    func getTableViewItems()
    
    //MARK: UITableview datasource and delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class AuthorInteractor: AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol?
    var authorNetworkWorker: AuthorNetworkWorkerProtocol?
    
    var tableViewItems: [SectionProtocol] = []
    var authorID: String?
    var categoryName: String?
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorAboutCell")
        return cell!
    }
}
