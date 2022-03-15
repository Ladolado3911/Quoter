//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import TTGTags
import Combine
import Firebase

var isExploreVCFiltered: Bool = false

protocol PresenterToFilterVCProtocol: AnyObject {
    
    var interactor: VCToFilterInteractorProtocol? { get set }
    
    func displayFetchedTags(selectionLimit: UInt, resultArr: [TTGTextTag])
    func addListener()
    func reloadCollectionView()
    func demolish(completion: @escaping () -> Void)
    func dismiss()
}

class FilterVC: UIViewController {
    
    var interactor: VCToFilterInteractorProtocol?

    lazy var tapOnBackgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapOnClose(sender:)))
        return gesture
    }()
    
    lazy var modalFinalFrame: CGRect = {
        let width = PublicConstants.screenWidth * 0.85
        let height = width * 1.5
        let x = view.bounds.width / 2 - (width / 2)
        let y = view.bounds.height / 2 - (height / 2)
        return CGRect(x: x, y: y, width: width, height: height)
    }()

    lazy var filterView: FilterView = {
        let filterView = FilterView(frame: view.initialFrame, finalFrame: modalFinalFrame)
        return filterView
    }()

    lazy var darkView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    lazy var collectionView: TTGTextTagCollectionView = {
        let collectionView = TTGTextTagCollectionView()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.alignment = .center
        collectionView.verticalSpacing = 30
        collectionView.horizontalSpacing = 30
        collectionView.enableTagSelection = true
        collectionView.alpha = 0
        return collectionView
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
        Sound.pop.play(extensionString: .wav)
        darkView.addGestureRecognizer(tapOnBackgroundGesture)
        filterView.addSubview(collectionView)
        filterView.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildView()
        interactor?.addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.cancelListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.requestToPopulateTags()
    }
    
    private func setSelected() {
        interactor?.setSelected(allTags: collectionView.allTags())
    }
    
    private func setup() {
        let vc = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.vc = vc
    }

    private func buildView() {
        view.addSubview(darkView)
        view.addSubview(filterView)
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.filterView.frame = self.modalFinalFrame
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.filterView.buildView()
                self.filterView.filterButton.addTarget(self,
                                                       action: #selector(self.didTapOnFilter(sender:)),
                                                       for: .touchUpInside)
                self.filterView.removeFilterButton.addTarget(self,
                                                             action: #selector(self.didTapOnClear(sender:)),
                                                             for: .touchUpInside)
                self.filterView.deselectButton.addTarget(self,
                                                         action: #selector(self.didTapOnDeselect(sender:)),
                                                         for: .touchUpInside)
                self.filterView.closeButton.addTarget(self,
                                                      action: #selector(self.didTapOnClose(sender:)),
                                                      for: .touchUpInside)
            }
        }
    }

    @objc func didTapOnClear(sender: UIButton) {
        interactor?.demolishView { [weak self] in
            guard let self = self else { return }
            Analytics.logEvent("did_tap_on_clear", parameters: nil)
            self.interactor?.dismiss(isExploreFiltered: false, type: .clear)
        }
    }
    
    @objc func didTapOnBackground(sender: UIButton) {
        interactor?.demolishView { [weak self] in
            guard let self = self else { return }
            self.interactor?.dismiss()
        }
    }
    
    @objc func didTapOnFilter(sender: UIButton) {
        interactor?.demolishView { [weak self] in
            guard let self = self else { return }
            Analytics.logEvent("did_tap_on_filter", parameters: nil)
            self.interactor?.dismiss(isExploreFiltered: true, type: .filter)
        }
    }
    
    @objc func didTapOnClose(sender: UIButton) {
        demolish { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    @objc func didTapOnDeselect(sender: UIButton) {
        interactor?.didTapOnDeselect(sender: sender, allSelectedTags: collectionView.allSelectedTags(), allTags: collectionView.allTags())
    }
}

extension FilterVC: TTGTextTagCollectionViewDelegate, UIScrollViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        interactor?.textTagCollectionView(textTagCollectionView, didTap: tag, at: index)
    }
}

extension FilterVC: PresenterToFilterVCProtocol {
    
    func displayFetchedTags(selectionLimit: UInt, resultArr: [TTGTextTag]) {
        collectionView.selectionLimit = selectionLimit
        collectionView.add(resultArr)
        setSelected()
    }
    
    func addListener() {
        if collectionView.allSelectedTags().count >= 1 {
            filterView.filterButton.isEnabled = true
            filterView.deselectButton.isSelected = true
        }
        else {
            filterView.filterButton.isEnabled = false
            filterView.deselectButton.isSelected = false
        }
        filterView.removeFilterButton.isEnabled = isExploreVCFiltered
    }
    
    func reloadCollectionView() {
        collectionView.reload()
    }
    
    func demolish(completion: @escaping () -> Void) {
        filterView.demolishView {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.filterView.frame = self.view.initialFrame
            } completion: { [weak self] didFinish in
                guard let self = self else { return }
                if didFinish {
                    UIView.animate(withDuration: 0.3) {
                        self.filterView.filterButton.alpha = 0
                        self.filterView.mainTitleLabel.alpha = 0
                        self.filterView.collectionView?.alpha = 0
                        self.filterView.deselectButton.alpha = 0
                    } completion: { didFinish in
                        if didFinish {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
}
