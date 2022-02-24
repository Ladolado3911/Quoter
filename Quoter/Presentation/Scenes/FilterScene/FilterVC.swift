//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import TTGTags
import GradientView

class FilterVC: UIViewController {
    
    var tags: [String] = []
    var tagLabels: [UILabel] = []
    
    lazy var gradientView1: UIView = {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height * 0.05
        let x: CGFloat = 0
        let y: CGFloat = 0
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.gray.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        //gradient.loca
        
       
        let gradientView = UIView(frame: frame)
        gradientView.layer.addSublayer(gradient)
        //gradientView.backgroundColor = .clear
        
        //gradientView.locations = [0.8, 1]
        return gradientView
        
    }()
    
    lazy var gradientView2: GradientView = {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height * 0.05
        let x: CGFloat = 0
        let y = collectionView.bounds.height * 0.9
        let frame = CGRect(x: x, y: y, width: width, height: height)
       
        let gradientView = GradientView(frame: frame)
        //gradientView.backgroundColor = .clear
        gradientView.direction = .vertical
        gradientView.colors = [.gray]
        //gradientView.locations = [0.8, 1]
        return gradientView
        
    }()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildView()
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
                let convertedToTags = filterObjects.map { $0.genre }
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
    
    private func addTargets() {
        
    }
    
    private func buildView() {
        view.addSubview(darkView)
        view.addSubview(filterView)
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.filterView.frame = self.modalFinalFrame
        } completion: { didFinish in
            if didFinish {
                self.filterView.buildView()
                self.collectionView.addSubview(self.gradientView1)
                self.collectionView.addSubview(self.gradientView2)
                self.collectionView.bringSubviewToFront(self.gradientView1)
                self.collectionView.bringSubviewToFront(self.gradientView2)
            }
        }
    }
    
    @objc func didTapOnBackground(sender: UITapGestureRecognizer) {
        self.filterView.demolishView {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.filterView.frame = self.view.initialFrame
            } completion: { didFinish in
                if didFinish {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

extension FilterVC: TTGTextTagCollectionViewDelegate {
    
}
