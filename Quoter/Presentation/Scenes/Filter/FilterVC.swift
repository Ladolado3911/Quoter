//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterVCProtocol {
    var interactor: FilterInteractorProtocol? { get set }
    var router: FilterRouterProtocol? { get set }
    
  
}

class FilterVC: UIViewController {
    var interactor: FilterInteractorProtocol?
    var router: FilterRouterProtocol?
    
    lazy var filterView: FilterView = {
        let frame = CGRect(x: 0,
                           y: view.bounds.height,
                           width: view.bounds.width,
                           height: view.bounds.height * 0.8169)
        let filter = FilterView(frame: frame)
        return filter
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildSubviews()
        showView()
    }
    
    private func setup() {
        let vc = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
        let exploreNetworkWorker = ExploreNetworkWorker()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func buildSubviews() {
        view.addSubview(filterView)
        view.bringSubviewToFront(filterView)
    }
    
    private func showView() {
        let transform = CGAffineTransform(translationX: 0, y: -filterView.bounds.height)
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.filterView.transform = transform
        }

    }
    
    private func hideView() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.filterView.transform = .identity
        }
    }
    
}

extension FilterVC: FilterVCProtocol {
    
}
