//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit
//import AppTrackingTransparency
import Firebase

protocol VCToExploreInteractorProtocol: AnyObject {
    var presenter: InteractorToExplorePresenterProtocol? { get set }
    
    var loadedVMs: [QuoteGardenQuoteVM] { get set }
    var loadedImages: [UIImage?] { get set }
    var selectedFilters: [String] { get set }
    var isLoadNewDataFunctionRunning: Bool { get set }
    var isDataLoaded: Bool  { get set }
    
    var currentPage: Int { get set }
    var capturedCurrentPage: Int { get set }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, bookGesture: UITapGestureRecognizer, filterGesture: UITapGestureRecognizer) -> UICollectionViewCell
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, completion: @escaping () -> Void)
    func requestDisplayInitialData()
    func resetInitialData()
    func requestDisplayNewData(edges: (Int, Int))
    func requestNewData(edges: (Int, Int), offsetOfPage: Int)
}

class ExploreInteractor: VCToExploreInteractorProtocol {
    var presenter: InteractorToExplorePresenterProtocol?
    
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImages: [UIImage?] = []
    var selectedFilters: [String] = [""]
    var isLoadNewDataFunctionRunning: Bool = false
    var isDataLoaded = false {
        didSet {
            isDataLoadedSubject.send(isDataLoaded)
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            //print(currentPage)
        }
    }
    var capturedCurrentPage: Int = 0

    func requestDisplayNewData(edges: (Int, Int)) {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: selectedFilters) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatNewData(currentVMs: self.loadedVMs,
                                          capturedPage: self.capturedCurrentPage,
                                          edges: edges,
                                          quoteModels: quoteModels,
                                          images: images)
        }
    }
    
    func requestDisplayInitialData() {
        let contentWorker = ExploreContentWorker()
        currentPage = 0
        capturedCurrentPage = 0
        contentWorker.getContent(genres: selectedFilters) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: quoteModels, images: images)
        }
    }
    
    func requestNewData(edges: (Int, Int), offsetOfPage: Int) {
        if currentPage == loadedVMs.count - offsetOfPage && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                requestDisplayNewData(edges: edges)
            }
        }
    }
    
    func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        selectedFilters.removeAll { $0 == "" }
        presenter?.startAnimating()
        requestDisplayInitialData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, bookGesture: UITapGestureRecognizer, filterGesture: UITapGestureRecognizer) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? QuoteCell
        cell?.quoteVM = loadedVMs[indexPath.item]
        cell?.mainImage = loadedImages[indexPath.item]
        cell?.tapOnBookGesture = bookGesture
        cell?.tapOnFilterGesture = filterGesture
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, completion: @escaping () -> Void) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        requestNewData(edges: (4, 14), offsetOfPage: 5)
        requestNewData(edges: (0, 10), offsetOfPage: 1)
        print(selectedFilters)
        if currentPage == loadedVMs.count - 1 && isLoadNewDataFunctionRunning {
            completion()
        }
    }
}
