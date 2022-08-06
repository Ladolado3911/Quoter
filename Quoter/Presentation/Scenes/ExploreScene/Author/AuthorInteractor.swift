//
//  AuthorInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit
import SDWebImage

protocol AuthorInteractorProtocol {
    var presenter: AuthorPresenterProtocol? { get set }
    var authorNetworkWorker: AuthorNetworkWorkerProtocol? { get set }
    
    var tableViewItems: [SectionProtocol] { get set }
    var authorID: String? { get set }
    var categoryName: String? { get set }
    var dataSourceInfo: AuthorDataSourceInfoProtocol? { get set }
    
    func showView()
    func hideView()
    
    //MARK: UITableview datasource and delegate functions
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, target: UIViewController)
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    
    //MARK: UICollectionview datasource and delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}

final class AuthorInteractor: AuthorInteractorProtocol {
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
        AuthorCellsManager.shared.everyCellObjects[indexPath.section][indexPath.row].willDisplay(cell, networkWorker: AuthorNetworkWorker())
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.text = AuthorCellsManager.shared.everyCellObjects[section].first!.sectionNameOfCell
            view.textLabel?.textColor = DarkModeColors.white
            view.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        }
        
        if let view = tableView.tableHeaderView as? AuthorTableHeaderView,
           let desc = AuthorCellsManager.shared.authorDesc,
           let imageString = AuthorCellsManager.shared.authorImageURLString,
           let url = URL(string: imageString) {
            let animationSize: CGFloat = 120
            view.createAndStartLoadingLottieAnimation(animation: .simpleLoading,
                                                      animationSpeed: 1,
                                                      frame: CGRect(x: view.bounds.width / 2 - (animationSize / 2),
                                                                    y: view.bounds.height / 2 - (animationSize / 2),
                                                                    width: animationSize,
                                                                    height: animationSize),
                                                      loopMode: .loop,
                                                      contentMode: .scaleAspectFit,
                                                      completion: nil)
            view.imageView.sd_setImage(with: url) { _, _, _, _ in
                view.descLabel.text = desc
                view.aboutLabel.text = "About"
                view.stopLoadingLottieAnimationIfExists()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTitleView.identifier) as? SectionTitleView {
            view.titleLabel.text = AuthorCellsManager.shared.everyCellObjects[section].first!.sectionNameOfCell
            return view
        }
        else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

}

extension AuthorInteractor {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.pickRelevantCellObject(using: AuthorCellsManager.shared)?.innerCollectionViewDataCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.pickRelevantCellObject(using: AuthorCellsManager.shared)?.dequeInnerCollectionViewCell(indexPath: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.pickRelevantCellObject(using: AuthorCellsManager.shared)?.didSelectInnerCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.pickRelevantCellObject(using: AuthorCellsManager.shared)?.sizeForInnerCollectionViewItemAt() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.pickRelevantCellObject(using: AuthorCellsManager.shared)?.willDisplayInnerCollectionViewCell(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
