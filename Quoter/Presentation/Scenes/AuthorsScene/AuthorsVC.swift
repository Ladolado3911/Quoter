//
//  ViewController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit

class AuthorsVC: UIViewController {
    
    let authorsView: AuthorsView = {
        let authorsView = AuthorsView()
        return authorsView
    }()
    
    override func loadView() {
        super.loadView()
        view = authorsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = AppColors.mainColor
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//        
////        navigationController?.navigationBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
////        navigationController?.navigationBar.layer.cornerRadius = 10
//        title = "Choose Quoter"
    }


}

