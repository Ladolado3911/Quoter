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
    
    func panFunc(sender: UIPanGestureRecognizer,
                 targetView: FilterView,
                 minY: CGFloat,
                 dragVelocity: CGPoint)

    func animate(to point: CGPoint)
    func animateColor()
    func dismiss()
}

class FilterVC: UIViewController {
    var interactor: FilterInteractorProtocol?
    var router: FilterRouterProtocol?
    
    lazy var filterView: FilterView = {
        let frame = CGRect(x: -5,
                           y: view.bounds.height,
                           width: view.bounds.width + 10,
                           height: view.bounds.height * 0.8169)
        let filter = FilterView(frame: frame)
        return filter
    }()
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panFunc(sender:)))
        return gesture
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFunc(sender:)))
        return gesture
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterView.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildSubviews()
        showView()
    }
    
    private func configCollectionView() {
        
    }
    
    @objc func tapFunc(sender: UITapGestureRecognizer) {
        interactor?.tapFunc(sender: sender, targetView: view)
    }
    
    @objc func panFunc(sender: UIPanGestureRecognizer) {
        interactor?.panFunc(sender: sender, targetView: filterView)
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
        interactor?.showView(targetView: filterView)
    }

    private func hideView() {
        self.interactor?.hideView()
    }
    
}

enum MovementDirection {
    case up
    case down
}

extension FilterVC: FilterVCProtocol {
    func panFunc(sender: UIPanGestureRecognizer,
                 targetView: FilterView,
                 minY: CGFloat,
                 dragVelocity: CGPoint) {
        interactor?.panFunc2(sender: sender, targetView: targetView, minY: minY, dragVelocity: dragVelocity)
    }

    func animate(to point: CGPoint) {
        filterView.frame.origin = point
    }
    
    func animateColor() {
        view.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
}
