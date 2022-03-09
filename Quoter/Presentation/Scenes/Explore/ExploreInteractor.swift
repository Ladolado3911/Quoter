//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToExploreInteractorProtocol: AnyObject {
    var presenter: InteractorToExplorePresenterProtocol? { get set }
    
    var loadedVMs: [QuoteGardenQuoteVM] { get set }
    var loadedImages: [UIImage?] { get set }
    var selectedFilters: [String] { get set }
    var isLoadNewDataFunctionRunning: Bool { get set }
    var isDataLoaded: Bool  { get set }
    
    var currentPage: Int { get set }
    var capturedCurrentPage: Int { get set }
    
    func requestDisplayInitialData()
    func resetInitialData()
    func requestDisplayNewData(genres: [String], currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int))
    func requestNewData(edges: (Int, Int), offsetOfPage: Int)
}

class ExploreInteractor: VCToExploreInteractorProtocol {
    var presenter: InteractorToExplorePresenterProtocol?
    
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImages: [UIImage?] = []
    var selectedFilters: [String] = [""]
    var isLoadNewDataFunctionRunning: Bool = false
    var isDataLoaded = false
    
    var currentPage: Int = 0 {
        didSet {
            print(currentPage)
        }
    }
    var capturedCurrentPage: Int = 0

    func requestDisplayNewData(genres: [String], currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int)) {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: genres) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatNewData(currentVMs: currentVMs,
                                          capturedPage: capturedPage,
                                          edges: edges,
                                          quoteModels: quoteModels,
                                          images: images)
        }
    }
    
    func requestDisplayInitialData() {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: selectedFilters) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: quoteModels, images: images)
        }
    }
    
    func requestNewData(edges: (Int, Int), offsetOfPage: Int) {
        presenter?.transfer(edges: edges, offsetOfPage: offsetOfPage)
    }
    
    func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        presenter?.startAnimating()
        requestDisplayInitialData()
    }
}
