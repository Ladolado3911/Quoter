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
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?], indexPaths: [IndexPath])
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath])
    func setTimer()
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
                if interactor?.counter == 13 {
                    router?.routeToSwipeHint(repeatCount: 2, delay: 1)
                    interactor?.invalidateTimer()
                    return
                }
            }
        }
        else {
            if interactor?.counter == 13 {
                router?.routeToSwipeHint(repeatCount: 2, delay: 1)
                interactor?.invalidateTimer()
                return
            }
        }
        interactor?.counter += 1
        print(interactor?.counter)
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.loadedVMs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = interactor?.collectionView(collectionView, cellForItemAt: indexPath, bookGesture: tapOnBookGesture, filterGesture: tapOnFilterGesture)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        Sound.windTransition2.play(extensionString: .mp3)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        interactor?.invalidateTimer()
        interactor?.requestToSetTimer()
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
                        indexPaths: [IndexPath]) {
        
        interactor?.loadedVMs.append(contentsOf: loadedVMs)
        interactor?.loadedImages.append(contentsOf: loadedImages)
        exploreView.collectionView.insertItems(at: indexPaths)
        exploreView.collectionView.isUserInteractionEnabled = true
        interactor?.isLoadNewDataFunctionRunning = false
        self.dismiss(animated: false)
    }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM],
                            loadedImages: [UIImage?],
                            indexPaths: [IndexPath]) {
        
        interactor?.loadedVMs = loadedVMs
        interactor?.loadedImages = loadedImages
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
}
