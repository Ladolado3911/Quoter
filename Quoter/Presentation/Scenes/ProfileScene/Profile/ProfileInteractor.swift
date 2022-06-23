//
//  ProfileInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
}

class ProfileInteractor: ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol?
}
