//
//  ModalAlertVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

class ModalAlertVC: UIViewController {
    
    let modalAlertView: ModalAlertView = {
        let modalAlertView = ModalAlertView()
        return modalAlertView
    }()
    
    override func loadView() {
        super.loadView()
        view = modalAlertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modalAlertView.buildView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalAlertView.buildView()
    }
}
