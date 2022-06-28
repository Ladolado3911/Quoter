//
//  ProfileVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfileVCProtocol: AnyObject {
    var interactor: ProfileInteractorProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
    var profileView: ProfileView? { get set }
}

class ProfileVC: UIViewController {
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?
    var profileView: ProfileView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        configCollectionView()
    }
    
    private func setup() {
        let vc = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        //let exploreNetworkWorker = ExploreNetworkWorker()
        let profileView = ProfileView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.profileView = profileView
        vc.router = router
        interactor.presenter = presenter
        //interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func configCollectionView() {
        profileView?.menuCollectionView.dataSource = self
        profileView?.menuCollectionView.delegate = self
    }
    
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}

extension ProfileVC: ProfileVCProtocol {
    
}
