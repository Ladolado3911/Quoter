//
//  AuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit


protocol AuthorVCProtocol: AnyObject {
    var interactor: AuthorInteractorProtocol? { get set }
    var router: AuthorRouterProtocol? { get set }
    
    func showView()
    func showContent()
    func hideView()
    func hideContent()
    func dismissView()
}

class AuthorVC: UIViewController {
    var interactor: AuthorInteractorProtocol?
    var router: AuthorRouterProtocol?
    
    lazy var authorView: AuthorView = {
        let frame = CGRect(x: Constants.screenWidth / 2,
                           y: Constants.screenHeight * 0.74,
                           width: 0,
                           height: 0)
        let autView = AuthorView(frame: frame)
        return autView
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        buildSubviews()
        configButtons()
        configTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.showView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthorCellsManager.shared.authorID = ""
        AuthorCellsManager.shared.authorName = ""
    }
    
    private func buildSubviews() {
        view.addSubview(authorView)
    }
    
    private func configButtons() {
        authorView.backButton.addTarget(self, action: #selector(onBackButton(sender:)), for: .touchUpInside)
    }
    
    private func configTableView() {
        authorView.tableView.dataSource = self
        authorView.tableView.delegate = self
        authorView.tableView.registerCells(using: AuthorCellsManager.shared, target: self)
        authorView.tableView.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: SectionTitleView.identifier)
        authorView.tableView.tableHeaderView = AuthorTableHeaderView(frame: CGRect(x: 0,
                                                                                   y: 0,
                                                                                   width: Constants.screenWidth,
                                                                                   height: 200))
        authorView.tableView.separatorStyle = .none
        authorView.titleLabel.text = AuthorCellsManager.shared.authorName
    }
    
    private func setup() {
        let vc = self
        let interactor = AuthorInteractor()
        let presenter = AuthorPresenter()
        let router = AuthorRouter()
        let authorNetworkWorker = AuthorNetworkWorker()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.authorNetworkWorker = authorNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    @objc func onBackButton(sender: UIButton) {
        interactor?.hideView()
    }
    
}

extension AuthorVC: AuthorVCProtocol {
    func showView() {
        authorView.frame = view.bounds
    }
    
    func showContent() {
        authorView.backView.alpha = 1
        authorView.backButton.alpha = 1
        authorView.tableView.alpha = 1
        authorView.titleLabel.alpha = 1
    }
    
    func hideView() {
        authorView.frame = CGRect(x: Constants.screenWidth / 2,
                                  y: Constants.screenHeight / 2,
                                  width: 0,
                                  height: 0)
    }
    
    func hideContent() {
        authorView.backButton.alpha = 0
        authorView.backView.alpha = 0
        authorView.tableView.alpha = 0
        authorView.titleLabel.alpha = 0
    }
    
    func dismissView() {
        dismiss(animated: false)
    }
}

extension AuthorVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        interactor?.numberOfSections(in: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        interactor?.tableView(tableView, heightForRowAt: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        interactor?.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        interactor?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        interactor?.tableView(tableView, willDisplay: cell, forRowAt: indexPath, target: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        interactor?.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        interactor?.tableView(tableView, viewForHeaderInSection: section)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        interactor?.tableView(tableView, heightForHeaderInSection: section) ?? 0
    }
}

extension AuthorVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        interactor?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    
}
