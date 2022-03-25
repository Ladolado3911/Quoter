//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit
import Firebase

//MARK: Explore Interactor Protocol

protocol VCToExploreInteractorProtocol: AnyObject {
    
    var presenter: InteractorToExplorePresenterProtocol? { get set }
    
    //MARK: Explore Interactor Protocol Properties
    
    var isFirstAppearanceOfExploreVC: Bool { get set }
    var counter: Int { get set }
    var timer: Timer? { get set }
    var comesFromFilter: Bool { get set }
    var isFirstLaunch: Bool { get set }
    var isCounterFirstLaunchForDeviceFirstLaunch: Bool { get set }
    var loadedVMs: [QuoteGardenQuoteVM] { get set }
    var loadedImages: [UIImage?] { get set }
    var loadedImageURLs: [String?] { get set }
    var selectedFilters: [String] { get set }
    var isLoadNewDataFunctionRunning: Bool { get set }
    var isLoadOldDataFunctionRunning: Bool { get set }
    var isDataLoaded: Bool  { get set }
    var currentPage: Int { get set }
    var capturedCurrentPage: Int { get set }
    
    //MARK: Explore Interactor Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath,
                        bookGesture: UITapGestureRecognizer,
                        filterGesture: UITapGestureRecognizer,
                        ideaTarget: ButtonTarget) -> UICollectionViewCell
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, completion: @escaping () -> Void)
    func requestDisplayInitialData()
    func resetInitialData()
    func invalidateTimer()
    func requestDisplayNewData(edges: (Int, Int))
    func requestNewData(edges: (Int, Int), offsetOfPage: Int)
    func requestToSetTimer()
    func requestToChangeIdeaState(isSwitchButtonSelected: Bool)
}

//MARK: Explore Interactor Class

class ExploreInteractor: VCToExploreInteractorProtocol {
    
    var presenter: InteractorToExplorePresenterProtocol?
    
    //MARK: Explore Interactor Class Properties
    
    var isFirstAppearanceOfExploreVC: Bool = true
    var counter: Int = 0
    var timer: Timer?
    var comesFromFilter: Bool = true
    var isFirstLaunch: Bool = false
    var isCounterFirstLaunchForDeviceFirstLaunch: Bool = true
    var loadedVMs: [QuoteGardenQuoteVM] = []
    
    var loadedImages: [UIImage?] = []
    var loadedImageURLs: [String?] = []
    
    var selectedFilters: [String] = [""]
    var isLoadNewDataFunctionRunning: Bool = false
    var isLoadOldDataFunctionRunning: Bool = false
    var isDataLoaded = false {
        didSet {
            isDataLoadedSubject.send(isDataLoaded)
        }
    }
    var currentPage: Int = 0
    var capturedCurrentPage: Int = 0
    
    //MARK: Explore Interactor Class Methods
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
    }
    
    func requestToSetTimer() {
        presenter?.setTimer()
    }
    
    func requestToChangeIdeaState(isSwitchButtonSelected: Bool) {
        let quoteVMM = loadedVMs[currentPage]
        let modalAlertImageWorker = ModalAlertImageWorker()
        
        if !isSwitchButtonSelected {
            Sound.idea.play(extensionString: .mp3)
        }
        self.presenter?.formatIdeaChange()
        
        modalAlertImageWorker.getAuthorImage(authorName: quoteVMM.authorName) { (image, imageType) in
            if let image = image {
                if isSwitchButtonSelected {
                    CoreDataWorker.removePair(quoteVM: quoteVMM)
                }
                else {
                    CoreDataWorker.addPair(quoteVM: quoteVMM, authorImageData: image.pngData())
                }
                collectionViewUpdateSubject.send {}
            }
            else {
                print("Could not unwrap")
            }
        }
    }

    func requestDisplayNewData(edges: (Int, Int)) {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: selectedFilters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (quoteModels, images, imageURLs)):
                self.presenter?.formatNewData(currentVMs: self.loadedVMs,
                                              capturedPage: self.capturedCurrentPage,
                                              edges: edges,
                                              quoteModels: quoteModels,
                                              images: images,
                                              imageURLs: imageURLs)
            case .failure(let error):
                print(error)
                // notify user and offer try again or cancel options
                //self.presenter?.presentNetworkErrorAlert()
                self.presenter?.presentNetworkErrorAlert()
                
                
            }
        }
    }
    
    func requestDisplayInitialData() {
        let contentWorker = ExploreContentWorker()
        currentPage = 0
        capturedCurrentPage = 0
        contentWorker.getContent(genres: selectedFilters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (quoteModels, images, imageURLs)):
                self.presenter?.formatData(quoteModels: quoteModels, images: images, imageURLs: imageURLs)
            case .failure(let error):
                print(error)
                // notify user and offer try again or cancel options
                self.presenter?.addWifiButtonIfNeeded()
                self.presenter?.presentInitialNetworkErrorAlert()
            }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath,
                        bookGesture: UITapGestureRecognizer,
                        filterGesture: UITapGestureRecognizer,
                        ideaTarget: ButtonTarget) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? QuoteCell
        cell?.quoteVM = loadedVMs[indexPath.item]
        cell?.mainImageStringURL = loadedImageURLs[indexPath.item]
        cell?.mainImage = loadedImages[indexPath.item]
        cell?.tapOnBookGesture = bookGesture
        cell?.tapOnFilterGesture = filterGesture
        cell?.ideaButtonTarget = ideaTarget
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, completion: @escaping () -> Void) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        requestNewData(edges: (4, 14), offsetOfPage: 5)
        requestNewData(edges: (0, 10), offsetOfPage: 1)
        
        if currentPage == loadedVMs.count - 1 && isLoadNewDataFunctionRunning {
            completion()
        }
        else {
            
        }
    }
}
