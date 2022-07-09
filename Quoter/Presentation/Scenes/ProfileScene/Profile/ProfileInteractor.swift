//
//  ProfileInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

protocol ProfileMenuItemProtocol {
    var icon: UIImage? { get set }
    var title: String { get set }
}

struct ProfileMenuItem: ProfileMenuItemProtocol {
    var icon: UIImage?
    var title: String
}

protocol ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    var menuItems: [ProfileMenuItem] { get set }
    var userIDString: String? { get set }
    var profileNetworkWorker: ProfileNetworkWorkerProtocol? { get set }
    
    func signoutUser()
    func setProfileContent()
}

class ProfileInteractor: ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol?
    var menuItems: [ProfileMenuItem] = [
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
        ProfileMenuItem(icon: ProfileIcons.galleryIcon, title: "Gallery"),
    ]
    var userIDString: String? = CurrentUserLocalManager.shared.getCurrentUserID()
    var profileNetworkWorker: ProfileNetworkWorkerProtocol?
    
    func signoutUser() {
        switch CurrentUserLocalManager.shared.type {
        case .quotie:
            break
        case .apple:
            break
        case .google:
            do {
                try Auth.auth().signOut()
            }
            catch {
                print("could not sign out with error: \(error)")
            }
        default:
            break
        }
        CurrentUserLocalManager.shared.deleteUserIDAfterSignOut()
    }
    
    func setProfileContent() {
        if let userIDString = userIDString {
            Task.init { [weak self] in
                guard let self = self else { return }
                let userProfileContent = try await profileNetworkWorker?.getUserProfileContent(using: userIDString)
                await MainActor.run {
                    
                    guard let userProfileContent = userProfileContent else { return }
                    print(userProfileContent.email)
                    self.presenter?.setProfileContent(content: userProfileContent)
                }
            }
        }
    }
}
