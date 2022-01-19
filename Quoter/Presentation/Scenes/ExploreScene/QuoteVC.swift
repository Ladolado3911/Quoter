//
//  QuoteVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class QuoteVC: UIViewController {
        
    let quoteView: QuoteView = {
        let quoteView = QuoteView()
        return quoteView
    }()
    
    override func loadView() {
        super.loadView()
        view = quoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
