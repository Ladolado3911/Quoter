//
//  ProfilePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfilePresenterProtocol {
    var vc: ProfileVCProtocol? { get set }
}

class ProfilePresenter: ProfilePresenterProtocol {
    var vc: ProfileVCProtocol?
}
