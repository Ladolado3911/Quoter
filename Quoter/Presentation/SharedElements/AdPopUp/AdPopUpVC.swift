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
    
    lazy var popUpView: AdPopUpView = {
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
        if let ratingView = popUpView.ratingVStack.arrangedSubviews[1] as? RatingView {
            //MARK: If for some reason rating stars does not appear, slightly increase 0.04 time below
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                ratingView.orangeViewCoefficient = ratingView.rating / 5
                ratingView.mask()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showView()
    }
}
