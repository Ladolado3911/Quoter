//
//  ProfileVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit
import FirebaseAnalytics

protocol ProfileVCProtocol: AnyObject {
    var interactor: ProfileInteractorProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
    var profileView: ProfileView? { get set }
    
    func present(vc: UIViewController)
    func setProfileContent(content: UserProfileContent)
    func accountDeletedSuccessfully()
    func accountDeleteFail(errorMessage: String)
}

final class ProfileVC: UIViewController {
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
//        interactor?.setProfileContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        configButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.setProfileContent()
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

    private func configButtons() {
        profileView?.signoutButton.addTarget(self, action: #selector(onSignoutButton(sender:)), for: .touchUpInside)
        profileView?.deleteAccountButton.addTarget(self, action: #selector(onDeleteButton(sender:)), for: .touchUpInside)
    }
    
}

extension ProfileVC {
    @objc func onSignoutButton(sender: UIButton) {
        Analytics.logEvent(#function, parameters: nil)
        interactor?.signoutUser()
        router?.routeToSigninVC()
    }
    
    @objc func onDeleteButton(sender: UIButton) {
        Analytics.logEvent(#function, parameters: nil)
        interactor?.deleteAccount()
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
    
    func accountDeletedSuccessfully() {
        presentAlert(title: "Alert",
                     text: "Account deleted",
                     mainButtonText: "ok",
                     mainButtonStyle: .default) { [weak self] in
            guard let self = self else { return }
            self.router?.routeToSigninVC()
        }
    }
    
    func accountDeleteFail(errorMessage: String) {
        presentAlert(title: "Alert",
                     text: errorMessage,
                     mainButtonText: "ok",
                     mainButtonStyle: .default) { 

        }
    }
}
