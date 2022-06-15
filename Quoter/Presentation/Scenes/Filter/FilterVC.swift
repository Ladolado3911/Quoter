//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterToExploreProtocol {
    func sendBackGenre(genre: Genre)
}

protocol FilterVCProtocol {
    var interactor: FilterInteractorProtocol? { get set }
    var router: FilterRouterProtocol? { get set }
    var filterToExploreDelegate: FilterToExploreProtocol? { get set }
    
    func panFunc(sender: UIPanGestureRecognizer,
                 targetView: FilterView,
                 minY: CGFloat,
                 dragVelocity: CGPoint)

    func animate(to point: CGPoint)
    func animateColor()
    func dismiss()
    
    func reloadCollectionViewData()
    
    func setCurrentGenreToLabel(genre: Genre)
    func selectCell(indexPath: IndexPath)
}

class FilterVC: UIViewController {
    var interactor: FilterInteractorProtocol?
    var router: FilterRouterProtocol?
    var filterToExploreDelegate: FilterToExploreProtocol?
    
    var currentGenre: Genre = .general
    
    lazy var filterView: FilterView = {
        let frame = CGRect(x: -5,
                           y: view.bounds.height,
                           width: view.bounds.width + 10,
                           height: view.bounds.height * 0.6181) 
        let filter = FilterView(frame: frame)
        return filter
    }()
    
    let dimmingView: UIView = {
        let dimming = UIView()
        dimming.backgroundColor = .clear
        dimming.translatesAutoresizingMaskIntoConstraints = false
        return dimming
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
        dimmingView.addGestureRecognizer(tapGesture)
        addTargets()
        buildSubviews()
        buildConstraints()
        interactor?.currentChosenCategory = currentGenre
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.showView(targetView: filterView, backView: view)
        interactor?.getCategories()
        interactor?.selectCell()
    }
    
    private func configCollectionView() {
        if let layout = filterView.collectionView.collectionViewLayout as? FilterLayout {
            layout.dataSource = self
            layout.delegate = self
        }
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
        interactor?.animatedDismiss(delegate: nil)
    }
    
    @objc func arrowDownButton(sender: UIButton) {
        interactor?.animatedDismiss(delegate: nil)
    }
    
    @objc func onFilterButton(sender: UIButton) {
        interactor?.animatedDismiss(delegate: filterToExploreDelegate)
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
        view.addSubview(dimmingView)
        view.bringSubviewToFront(filterView)
        view.bringSubviewToFront(dimmingView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3819)
        ])
    }
    
    private func addTargets() {
        filterView.cancelButton.addTarget(self, action: #selector(cancelButton(sender:)), for: .touchUpInside)
        filterView.arrowButton.addTarget(self, action: #selector(arrowDownButton(sender:)), for: .touchUpInside)
        filterView.filterButton.addTarget(self, action: #selector(onFilterButton(sender:)), for: .touchUpInside)
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

extension FilterVC: FilterLayoutDataSource, FilterLayoutDelegate {

    func heightOfAllItems(collectionView: UICollectionView) -> CGFloat {
        interactor?.heightOfAllItems(collectionView: collectionView) ?? 0
    }

    func horizontalSpacing() -> CGFloat {
        Constants.screenWidth * 0.046875
    }

    func verticalSpacing(collectionView: UICollectionView) -> CGFloat {
        Constants.screenWidth * 0.046875
    }

    func widthForItem(indexPath: IndexPath) -> CGFloat {
        interactor?.widthForItem(indexPath: indexPath) ?? 0
    }
    
    func setCurrentGenreToLabel(genre: Genre) {
        filterView.subTitleLabel.text = genre.rawValue.capitalized
    }
    
    func selectCell(indexPath: IndexPath) {
        filterView.collectionView.delegate?.collectionView?(filterView.collectionView, didSelectItemAt: indexPath)
    }
}

extension FilterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        interactor?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
