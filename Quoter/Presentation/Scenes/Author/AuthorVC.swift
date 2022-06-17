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
    
    private func buildSubviews() {
        view.addSubview(authorView)
    }
    
    private func configButtons() {
        authorView.backButton.addTarget(self, action: #selector(onBackButton(sender:)), for: .touchUpInside)
    }
    
    private func configTableView() {
        authorView.tableView.dataSource = self
        authorView.tableView.delegate = self
        for object in AuthorCellsManager.shared.everyCellObjects {
            object.registerCell(authorView.tableView)
        }
        //authorView.tableView.register(AuthorAboutCell.self, forCellReuseIdentifier: "authorAboutCell")
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
    }
    
    func dismissView() {
        dismiss(animated: false)
    }
}

extension AuthorVC: UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //interactor?.numberOfSections(in: tableView)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        interactor?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        interactor?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        interactor?.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
}

