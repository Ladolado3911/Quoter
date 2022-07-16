//
//  TestVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit
import Combine

let globalUserIsSignedInSubject = PassthroughSubject<Bool, Never>()

protocol GalleryVCProtocol: AnyObject {
    var interactor: GalleryInteractorProtocol? { get set }
    var router: GalleryRouterProtocol? { get set }
    var galleryView: GalleryView? { get set }
    
    func present(vc: UIViewController)
    func showInfoLabel()
    func reloadData()
    func didSelect(quoteContent: String?, authorName: String?, imageURLString: String?)
}

class GalleryVC: UIViewController {
    
    var interactor: GalleryInteractorProtocol?
    var router: GalleryRouterProtocol?
    var galleryView: GalleryView?
    
    var cancellables: Set<AnyCancellable> = []
    
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
        view = galleryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        addListeners()
        view.backgroundColor = DarkModeColors.mainBlack
        globalUserIsSignedInSubject.send(CurrentUserLocalManager.shared.isUserSignedIn)
        //interactor?.setUserQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if CurrentUserLocalManager.shared.isUserSignedIn {
//            interactor?.setUserQuotes()
//        }
//        else {
//            galleryView?.showInfoLabel(with: "Sign in to use gallery")
//        }
        
    }
    
    private func setup() {
        let vc = self
        let interactor = GalleryInteractor()
        let presenter = GalleryPresenter()
        let router = GalleryRouter()
        let galleryNetworkWorker = GalleryNetworkWorker()
        let galleryView = GalleryView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.galleryView = galleryView
        vc.router = router
        interactor.presenter = presenter
        interactor.galleryNetworkWorker = galleryNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func addListeners() {
        globalUserIsSignedInSubject
            .sink { [weak self] isSignedIn in
                guard let self = self else { return }
                if isSignedIn {
                    self.interactor?.setUserQuotes()
                }
                else {
                    self.galleryView?.hideCollectionView()
                    self.galleryView?.showInfoLabel(with: "Sign in to use gallery")
                }
            }
            .store(in: &cancellables)
    }
    
    private func configCollectionView() {
        let collectionView = galleryView?.collectionView
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)
    }
    
}

extension GalleryVC: GalleryVCProtocol {
    
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func showInfoLabel() {
        galleryView?.hideCollectionView()
        galleryView?.showInfoLabel(with: "No quotes. Go to explore to add quotes")
    }
    
    func reloadData() {
        galleryView?.hideInfoLabel()
        galleryView?.showCollectionView()
        galleryView?.collectionView.reloadData()
    }
    
    func didSelect(quoteContent: String?, authorName: String?, imageURLString: String?) {
        router?.routeToGallerySubScene(quoteContent: quoteContent, authorName: authorName, imageURLString: imageURLString)
    }
    
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        interactor?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
}
