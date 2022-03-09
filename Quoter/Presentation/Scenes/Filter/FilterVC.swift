//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import TTGTags
import Combine

var isExploreVCFiltered: Bool = false

protocol PresenterToFilterVCProtocol: AnyObject {
    
    var interactor: VCToFilterInteractorProtocol? { get set }
    
    func displayFetchedTags(selectionLimit: UInt, resultArr: [TTGTextTag])
}

class FilterVC: UIViewController {
    
    var interactor: VCToFilterInteractorProtocol?
    
    private var cancellables: Set<AnyCancellable> = []
    let selectedCountSubject = PassthroughSubject<(() -> Void), Never>()
    
    var selectedTagStrings: [String] = []
    var dismissClosure: (([String]) -> Void)?

    lazy var tapOnBackgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapOnBackground(sender:)))
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
        selectedCountSubject
            .sink { [weak self] closure in
                guard let self = self else { return }
                if self.collectionView.allSelectedTags().count >= 1 {
                    self.filterView.filterButton.isEnabled = true
                    self.filterView.deselectButton.isSelected = true
                }
                else {
                    self.filterView.filterButton.isEnabled = false
                    self.filterView.deselectButton.isSelected = false
                }
                self.filterView.removeFilterButton.isEnabled = isExploreVCFiltered
            }
            .store(in: &cancellables)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.requestToPopulateTags()
    }
    
    private func setSelected() {
        for tag in collectionView.allTags() {
            if selectedTagStrings.contains(tag.content.getAttributedString().string) {
                tag.selected = true
            }
        }
        selectedCountSubject.send {}
        collectionView.reload()
    }
    
    private func setup() {
        let vc = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.vc = vc
    }
    
//    private func populateTags() {
//        QuoteGardenManager.getGenres { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let filterObjects):
//                let convertedToTags = filterObjects.map { $0.genre.capitalized }
//                var resultArr: [TTGTextTag] = []
//                for tag in convertedToTags {
//    
//                    let content = TTGTextTagStringContent(text: tag)
//                    content.textColor = .black
//                    let style = TTGTextTagStyle()
//                    style.backgroundColor = .white
//                    style.textAlignment = .center
//                    style.extraSpace = CGSize(width: 10, height: 10)
//                    
//                    let selectedContent = TTGTextTagStringContent(text: tag)
//                    selectedContent.textColor = .white
//                    let selectedStyle = TTGTextTagStyle()
//                    selectedStyle.backgroundColor = .black
//                    selectedStyle.textAlignment = .center
//                    selectedStyle.extraSpace = CGSize(width: 10, height: 10)
//
//                    let selectedTextTag = TTGTextTag(content: content, style: style, selectedContent: selectedContent, selectedStyle: selectedStyle)
//                    resultArr.append(selectedTextTag)
//                }
//                self.collectionView.selectionLimit = UInt(convertedToTags.count - 1)
//                self.collectionView.add(resultArr)
//                self.setSelected()
//            case .failure(let error):
//                print(error)
//            }
//        }
 //   }

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
    
    private func demolish(completion: @escaping () -> Void) {
        self.filterView.demolishView {
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
    
    @objc func didTapOnClear(sender: UIButton) {
        demolish { [weak self] in
            guard let self = self else { return }
            if let dismissClosure = self.dismissClosure {
                isExploreVCFiltered = false
                dismissClosure([""])
            }
        }
    }
    
    @objc func didTapOnBackground(sender: UIButton) {
        demolish { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    @objc func didTapOnFilter(sender: UIButton) {
        demolish { [weak self] in
            guard let self = self else { return }
            if let dismissClosure = self.dismissClosure {
                isExploreVCFiltered = true
                dismissClosure(self.selectedTagStrings)
            }
        }
    }
    
    @objc func didTapOnClose(sender: UIButton) {
        demolish { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    @objc func didTapOnDeselect(sender: UIButton) {
        if sender.isSelected {
            collectionView.allSelectedTags().forEach { tag in
                tag.selected = false
            }
        }
        else {
            collectionView.allTags().forEach { tag in
                tag.selected = true
            }
        }
        collectionView.reload()
        selectedCountSubject.send {}
        selectedTagStrings.removeAll()
    }
}

extension FilterVC: TTGTextTagCollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        selectedCountSubject.send {}
        if tag.selected {
            selectedTagStrings.append(tag.content.getAttributedString().string)
        }
        else {
            selectedTagStrings.removeAll { $0 == tag.content.getAttributedString().string }
        }
    }
}

extension FilterVC: PresenterToFilterVCProtocol {
    
    func displayFetchedTags(selectionLimit: UInt, resultArr: [TTGTextTag]) {
        collectionView.selectionLimit = selectionLimit
        collectionView.add(resultArr)
        setSelected()
    }
    
}
