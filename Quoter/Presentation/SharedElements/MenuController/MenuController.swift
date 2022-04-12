//
//  MenuController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuController: UIViewController {
    
    lazy var menuView: MenuView = {
        let width = view.bounds.width * 0.521875
        let frame = CGRect(x: -width, y: 0, width: width, height: view.bounds.height)
        let view = MenuView(frame: frame)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        if let firstItem = MenuModels.shared.menuItems.first {
            addChild(firstItem.viewController)
            view.addSubview(firstItem.viewController.view)
        }
    }
    
    
    
    
}
