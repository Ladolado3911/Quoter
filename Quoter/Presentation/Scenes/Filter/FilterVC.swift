//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit
import TTGTags

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
    
    func reloadCollectionViewData()
}

class FilterVC: UIViewController {
    var interactor: FilterInteractorProtocol?
    var router: FilterRouterProtocol?
    
    lazy var filterView: FilterView = {
        let frame = CGRect(x: -5,
                           y: view.bounds.height,
                           width: view.bounds.width + 10,
                           height: view.bounds.height * 0.6181) 
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        filterView.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        addTargets()
        buildSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.showView(targetView: filterView, backView: view)
        interactor?.getCategories()
    }
    
    private func configCollectionView() {
        filterView.collectionView.dataSource = self
        filterView.collectionView.delegate = self
        filterView.collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "filterCell")
    }
    
    @objc func tapFunc(sender: UITapGestureRecognizer) {
        interactor?.tapFunc(sender: sender, targetView: view)
    }
    
    @objc func panFunc(sender: UIPanGestureRecognizer) {
        interactor?.panFunc(sender: sender, targetView: filterView)
    }
    
    @objc func cancelButton(sender: UIButton) {
        interactor?.animatedDismiss()
    }
    
    @objc func arrowDownButton(sender: UIButton) {
        interactor?.animatedDismiss()
    }

    private func setup() {
        let vc = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
        let filterNetworkWorker = FilterNetworkWorker()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.filterNetworkWorker = filterNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func buildSubviews() {
        view.addSubview(filterView)
        view.bringSubviewToFront(filterView)
    }
    
    private func addTargets() {
        filterView.cancelButton.addTarget(self, action: #selector(cancelButton(sender:)), for: .touchUpInside)
        filterView.arrowButton.addTarget(self, action: #selector(arrowDownButton(sender:)), for: .touchUpInside)
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
        interactor?.panFunc2(sender: sender, targetView: targetView, backView: view, minY: minY, dragVelocity: dragVelocity)
    }

    func animate(to point: CGPoint) {
        filterView.frame.origin = point
    }
    
    func animateColor() {
        view.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.8)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func reloadCollectionViewData() {
        filterView.collectionView.reloadData()
    }
}

extension FilterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        interactor?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
