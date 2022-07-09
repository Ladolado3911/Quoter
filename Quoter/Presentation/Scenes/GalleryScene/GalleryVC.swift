//
//  TestVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

protocol GalleryVCProtocol: AnyObject {
    var interactor: GalleryInteractorProtocol? { get set }
    var router: GalleryRouterProtocol? { get set }
    var galleryView: GalleryView? { get set }
    
    func present(vc: UIViewController)
}

class GalleryVC: UIViewController {
    
    var interactor: GalleryInteractorProtocol?
    var router: GalleryRouterProtocol?
    var galleryView: GalleryView?
    
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
        view.backgroundColor = DarkModeColors.mainBlack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CurrentUserLocalManager.shared.isUserSignedIn {
            galleryView?.showInfoLabel(with: "No quotes. Go to explore to add quotes")
        }
        else {
            galleryView?.showInfoLabel(with: "Sign in to use gallery")
        }
        
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
    
}

extension GalleryVC: GalleryVCProtocol {
    
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
    
}
