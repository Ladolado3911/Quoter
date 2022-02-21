//
//  LoadingAlertVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/21/22.
//

import UIKit

class LoadingAlertVC: UIViewController {
    
    let modalAlertView: ModalAlertView = {
        let modalAlertView = ModalAlertView()
        return modalAlertView
    }()
    
    override func loadView() {
        super.loadView()
        view = modalAlertView
        Sound.pop.play(extensionString: .wav)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalAlertView.buildView()
    }
}
