//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit

class FilterVC: UIViewController {
    
    var tags: [String] = []
    var tagLabels: [UILabel] = []
    
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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alpha = 0
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "tagCell")
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
                
                for object in filterObjects {
                    let label = UILabel()
                    label.text = object.genre
                    label.textColor = .black
                    label.textAlignment = .center
                    label.adjustsFontSizeToFitWidth = true
                    label.sizeToFit()
                    self.tagLabels.append(label)
                }
                
//                let tags = filterObjects.map { $0.genre }
//                self.tags = tags
                self.collectionView.reloadData()
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

extension FilterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCell
        //cell?.tagLabel.text = tags[indexPath.item]
        cell?.tagLabel2 = tagLabels[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        tagLabel2.frame = tagLabel.frame.inset(by: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
        CGSize(width: tagLabels[indexPath.item].frame.inset(by: UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)).width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //cell.
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
