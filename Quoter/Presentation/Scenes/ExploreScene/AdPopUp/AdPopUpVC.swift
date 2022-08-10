//
//  AdPopUpVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class AdPopUpVC: UIViewController, PopUpVCProtocol {
    
    lazy var dimmingView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var popUpView: PopUpViewProtocol = {
        let x: CGFloat = (view.bounds.width / 2)
        let y: CGFloat = (view.bounds.height / 2)
        let finalRect = CGRect(x: x, y: y, width: 0, height: 0)
        let adView = AdPopUpView(frame: finalRect)
        return adView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(dimmingView)
        view.addSubview(popUpView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showView()
    }
}
