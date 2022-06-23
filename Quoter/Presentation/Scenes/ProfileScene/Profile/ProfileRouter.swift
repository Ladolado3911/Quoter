//
//  ProfileRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol ProfileRouterProtocol {
    var vc: ProfileVCProtocol? { get set }
    
    
}

class ProfileRouter: ProfileRouterProtocol {
    weak var vc: ProfileVCProtocol?
    
    
}
