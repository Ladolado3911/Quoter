//
//  ProfileInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

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
}
