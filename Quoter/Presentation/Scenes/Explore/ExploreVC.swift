//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import SnapKit
import AnimatedCollectionViewLayout
import Combine
import Firebase

let isDataLoadedSubject = CurrentValueSubject<Bool, Never>(false)
let isFirstLaunchSubject = CurrentValueSubject<Bool, Never>(false)

protocol PresenterToExploreVCProtocol: AnyObject {
    var interactor: VCToExploreInteractorProtocol? { get set }
    
    func startAnimating()
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM],
                            loadedImages: [UIImage?],
                            indexPaths: [IndexPath],
                            imageURLs: [String?])
    
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath],
                        imageURLs: [String?])
    
    func setTimer()
    func displayIdeaChange()
}

class ExploreVC: MonitoredVC {
    
    var interactor: VCToExploreInteractorProtocol?
    var router: ExploreRouterProtocol?

    var tapOnBookGesture: UITapGestureRecognizer {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnBook(sender:)))
        return tapOnGesture
    }
    
    var tapOnFilterGesture: UITapGestureRecognizer {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnFilter(sender:)))
        return tapOnGesture
    }
    
    var tapOnIdeaGesture: UITapGestureRecognizer {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(onIdeaButton(sender:)))
        return tapOnGesture
    }
    
    var ideaButtonTarget: ButtonTarget {
        let target = ButtonTarget(target: self,
                                  selector: #selector(onIdeaButton(sender:)),
                                  event: .touchUpInside)
        return target
    }

    lazy var exploreView: ExploreView = {
        let view = ExploreView(frame: view.bounds)
        return view
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
        view = exploreView
        if !UIApplication.isAppAlreadyLaunchedOnce() {
            self.interactor?.isFirstLaunch = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        exploreView.startAnimating()
        interactor?.requestDisplayInitialData()
        configCollectionView()

//        interactor?.requestToTrack()
    }

    private func setup() {
        let vc = self
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        let router = ExploreRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }
    
    private func configCollectionView() {
        exploreView.collectionView.dataSource = self
        exploreView.collectionView.delegate = self
        exploreView.collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if exploreView.lottieAnimation != nil {
            connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))
        }
        else {
            if !interactor!.isDataLoaded {
                exploreView.startAnimating()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let isDataLoaded = interactor?.isDataLoaded else { return }
        if isDataLoaded {
            interactor?.requestToSetTimer()
        }
//
//        if let currentCell = exploreView.collectionView.cellForItem(at: IndexPath(item: interactor!.currentPage, section: 0)) as? QuoteCell {
//            let ideaButton = currentCell.quoteView.ideaButton
//            ideaButton.isSelected = CoreDataWorker.isQuoteInCoreData(quoteVM: interactor!.loadedVMs[interactor!.currentPage])
//        }
        //interactor?.requestToTrack()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if exploreView.lottieAnimation != nil {
            exploreView.stopLottieAnimation()
            exploreView.lottieAnimation = nil
        }
        if interactor?.timer != nil {
            interactor?.invalidateTimer()
        }
        interactor?.isFirstAppearanceOfExploreVC = false
    }
    
    @objc func didTapOnBook(sender: UITapGestureRecognizer) {
        Analytics.logEvent("did_tap_on_book", parameters: nil)
        interactor?.invalidateTimer()
        router?.routeToModalAlertVC(quoteVM: interactor!.loadedVMs[interactor!.currentPage]) { [weak self] in
            guard let self = self else { return }
            self.interactor?.requestToSetTimer()
        }
    }
    
    @objc func didTapOnFilter(sender: UITapGestureRecognizer) {
        Analytics.logEvent("did_tap_on_filter", parameters: nil)
        interactor?.invalidateTimer()
        router?.routeToFilters { [weak self] in
            guard let self = self else { return }
            self.interactor?.requestToSetTimer()
        }
    }
    
    @objc func onIdeaButton(sender: UIButton) {
        Analytics.logEvent("did_tap_on_Idea", parameters: nil)
        interactor?.requestToChangeIdeaState(isSwitchButtonSelected: sender.isSelected)
        sender.isSelected.toggle()
    }
    
    @objc func timerFire(sender: Timer) {
        if interactor!.isFirstLaunch {
            if interactor!.isCounterFirstLaunchForDeviceFirstLaunch {
                if interactor?.counter == 2 {
                    router?.routeToSwipeHint(repeatCount: 2, delay: 1)
                    interactor?.invalidateTimer()
                    interactor?.isCounterFirstLaunchForDeviceFirstLaunch = false
                    return
                }
            }
            else {
                if interactor?.counter == 20 {
                    router?.routeToSwipeHint(repeatCount: 2, delay: 1)
                    interactor?.invalidateTimer()
                    return
                }
            }
        }
        else {
            if interactor?.counter == 20 {
                router?.routeToSwipeHint(repeatCount: 2, delay: 1)
                interactor?.invalidateTimer()
                return
            }
        }
        interactor?.counter += 1
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.loadedVMs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = interactor?.collectionView(collectionView, cellForItemAt: indexPath, bookGesture: tapOnBookGesture, filterGesture: tapOnFilterGesture, ideaTarget: ideaButtonTarget)
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        interactor?.invalidateTimer()
        print(interactor!.loadedVMs.count)
        print("current page \(interactor!.currentPage)")
        //interactor?.requestToSetTimer()
        interactor?.scrollViewDidEndDecelerating(scrollView) { [weak self] in
            guard let self = self else { return }
            Analytics.logEvent("did_scroll", parameters: nil)
            self.router?.routeToLoadingAlertVC()
        }
    }
}

extension ExploreVC: PresenterToExploreVCProtocol {
    
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath],
                        imageURLs: [String?]) {

        interactor?.loadedVMs.append(contentsOf: loadedVMs)
        interactor?.loadedImages.append(contentsOf: loadedImages)
        interactor?.loadedImageURLs.append(contentsOf: imageURLs)

        interactor?.loadedImages.removeSubrange(0..<interactor!.currentPage)
        interactor?.loadedVMs.removeSubrange(0..<interactor!.currentPage)
        interactor?.loadedImageURLs.removeSubrange(0..<interactor!.currentPage)

        exploreView.collectionView.reloadData()
        interactor?.currentPage = 0
        interactor?.capturedCurrentPage = 0
        exploreView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)

        exploreView.collectionView.isUserInteractionEnabled = true
        interactor?.isLoadNewDataFunctionRunning = false
        self.dismiss(animated: false)
    }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM],
                            loadedImages: [UIImage?],
                            indexPaths: [IndexPath],
                            imageURLs: [String?]) {
        
        interactor?.loadedVMs = loadedVMs
        
        interactor?.loadedImages = loadedImages
        interactor?.loadedImageURLs = imageURLs
        
        exploreView.collectionView.insertItems(at: indexPaths)
        if exploreView.lottieAnimation != nil {
            exploreView.stopLottieAnimation()
        }
        interactor?.isDataLoaded = true
        if interactor!.isFirstAppearanceOfExploreVC {
            interactor?.requestToSetTimer()
        }
    }
    
    func startAnimating() {
        exploreView.collectionView.reloadData()
        exploreView.startAnimating()
    }
    
    func setTimer() {
        interactor?.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFire(sender:)), userInfo: nil, repeats: true)
    }
    
    func displayIdeaChange() {
    
    }
}
