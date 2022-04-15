//
//  ExploreVCTemp.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class ExploreVC: BaseVC {
    
    lazy var gradientView: UIView = {
        let gradient = CAGradientLayer()
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .clear
        gradient.frame = view.bounds
        gradient.colors = [DarkModeColors.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 0.6161]
        view.layer.addSublayer(gradient)
        return view
    }()
    
    lazy var tempImageView: UIImageView = {
        let imgView = UIImageView(frame: view.bounds)
        imgView.image = UIImage(named: "business")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(gradientView)
        //view.backgroundColor = .red
        //view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(tempImageView)
        view.bringSubviewToFront(blurEffectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(gradientView)
    }
    
}
