//
//  SignupRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//
import UIKit

protocol SignupRouterProtocol {
    var vc: SignupVCProtocol? { get set }
    
    
}

class SignupRouter: SignupRouterProtocol {
    weak var vc: SignupVCProtocol?
    
    
}
