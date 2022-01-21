//
//  QuoteVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class QuoteVC: UIViewController {
    
    var quoteVM: QuoteVM? {
        didSet {
            configWithVM()
        }
    }
        
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
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        quoteView.quoteTextView.text = quoteVM.content
        view.layoutIfNeeded()
    }
}
