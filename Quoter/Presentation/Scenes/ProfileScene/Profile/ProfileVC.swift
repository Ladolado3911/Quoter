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
    
    func present(vc: UIViewController)
    func setProfileContent(content: UserProfileContent)
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
    
    override func loadView() {
        super.loadView()
        interactor?.setProfileContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        //configCollectionView()
        configButtons()
    }
    
    private func setup() {
        let vc = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        let profileNetworkWorker = ProfileNetworkWorker()
        let profileView = ProfileView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.profileView = profileView
        vc.router = router
        interactor.presenter = presenter
        interactor.profileNetworkWorker = profileNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
//    private func configCollectionView() {
//        profileView?.menuCollectionView.dataSource = self
//        profileView?.menuCollectionView.delegate = self
//        profileView?.menuCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: "ProfileCell")
//    }
    
    private func configButtons() {
        profileView?.signoutButton.addTarget(self, action: #selector(onSignoutButton(sender:)), for: .touchUpInside)
    }
    
}

extension ProfileVC {
    @objc func onSignoutButton(sender: UIButton) {
        interactor?.signoutUser()
        router?.routeToSigninVC()
    }
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.menuItems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = interactor?.menuItems[indexPath.item]
        if let cell = cell as? ProfileMenuCell {
            cell.buildSubviews()
            cell.buildConstraints()
            cell.iconImageView.image = item?.icon
            cell.menuItemTitleLabel.text = item?.title
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.height / 2) * 1.3837,
               height: collectionView.bounds.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension ProfileVC: ProfileVCProtocol {
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func setProfileContent(content: UserProfileContent) {
        profileView?.userNameLabel.text = content.email
    }
}
