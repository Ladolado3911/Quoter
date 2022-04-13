//
//  ExploreVCTemp.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class ExploreVC: BaseVC {
    
    lazy var tempImageView: UIImageView = {
        let imgView = UIImageView(frame: view.bounds)
        imgView.image = UIImage(named: "business")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red
        view.addSubview(tempImageView)
        view.bringSubviewToFront(blurEffectView)
    }
    
}
