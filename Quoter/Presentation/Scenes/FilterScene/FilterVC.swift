//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import TTGTags
import Combine

class FilterVC: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    let selectedCountSubject = PassthroughSubject<(() -> Void), Never>()

//    lazy var gradientView1: UIView = {
//
//        let width = collectionView.bounds.width
//        let height = collectionView.bounds.height * 0.05
//        let x: CGFloat = 0
//        let y: CGFloat = 0
//        let frame = CGRect(x: x, y: y, width: width, height: height)
//
//        let gradientView = UIView(frame: frame)
//        let gradient = CAGradientLayer()
//        gradient.frame = frame
//        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
//        gradient.startPoint = CGPoint(x: 0.5, y: 1)
//        gradient.endPoint = CGPoint(x: 0.5, y: 0)
//        //gradient.locations = [0.8, 1]
//
//
//        gradientView.layer.addSublayer(gradient)
//        //gradientView.backgroundColor = .clear
//
//        return gradientView
//
//    }()
//
//    lazy var gradientView2: GradientView = {
//
//        let width = collectionView.bounds.width
//        let height = collectionView.bounds.height * 0.05
//        let x: CGFloat = 0
//        let y = collectionView.bounds.height * 0.9
//        let frame = CGRect(x: x, y: y, width: width, height: height)
//
//        let gradientView = GradientView(frame: frame)
//        //gradientView.backgroundColor = .clear
//        gradientView.direction = .vertical
//        gradientView.colors = [.gray]
//        //gradientView.locations = [0.8, 1]
//        return gradientView
//
//    }()
    
    lazy var tapOnBackgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapOnBackground(sender:)))
        return gesture
    }()
    
    lazy var modalFinalFrame: CGRect = {
        let width = PublicConstants.screenWidth * 0.85
        let height = width * 1.3
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
        
        //collectionView.register(TagCell.self, forCellWithReuseIdentifier: "tagCell")
        return collectionView
    }()

    override func loadView() {
        super.loadView()
        Sound.pop.play(extensionString: .wav)
        darkView.addGestureRecognizer(tapOnBackgroundGesture)
        filterView.addSubview(collectionView)
        filterView.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //buildView()
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
                }
                else {
                    self.filterView.filterButton.isEnabled = false
                }
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
        populateTags()
    }
    
    private func populateTags() {
        QuoteGardenManager.getGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let filterObjects):
                let convertedToTags = filterObjects.map { $0.genre.capitalized }
                var resultArr: [TTGTextTag] = []
                for tag in convertedToTags {
                    
                    let content = TTGTextTagStringContent(text: tag)
                    content.textColor = .black
                    let style = TTGTextTagStyle()
                    style.backgroundColor = .white
                    style.textAlignment = .center
                    style.extraSpace = CGSize(width: 10, height: 10)
                    
                    let selectedContent = TTGTextTagStringContent(text: tag)
                    selectedContent.textColor = .white
                    let selectedStyle = TTGTextTagStyle()
                    selectedStyle.backgroundColor = .black
                    selectedStyle.textAlignment = .center
                    selectedStyle.extraSpace = CGSize(width: 10, height: 10)
                    
                    //let textTag = TTGTextTag(content: content, style: style)
                    let selectedTextTag = TTGTextTag(content: content, style: style, selectedContent: selectedContent, selectedStyle: selectedStyle)
                    
                    resultArr.append(selectedTextTag)
                }
                self.collectionView.selectionLimit = UInt(convertedToTags.count - 1)
                self.collectionView.add(resultArr)
                self.collectionView.reload()
            case .failure(let error):
                print(error)
            }
        }
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
//                self.collectionView.addSubview(self.gradientView1)
//                self.collectionView.addSubview(self.gradientView2)
//                self.collectionView.bringSubviewToFront(self.gradientView1)
//                self.collectionView.bringSubviewToFront(self.gradientView2)
                self.filterView.filterButton.addTarget(self,
                                                       action: #selector(self.didTapOnFilter(sender:)),
                                                       for: .touchUpInside)
            }
        }
    }
    
    private func demolish() {
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
                    } completion: { didFinish in
                        if didFinish {
                            self.dismiss(animated: true)
                        }
                    }

                }
            }
        }
    }
    
    @objc func didTapOnBackground(sender: UITapGestureRecognizer) {
        demolish()
    }
    
    @objc func didTapOnFilter(sender: UITapGestureRecognizer) {
        demolish()
    }
}

extension FilterVC: TTGTextTagCollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        selectedCountSubject.send {}
        print("select")
        print(collectionView.allSelectedTags().count)
    }
    
}
