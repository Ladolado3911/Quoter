//
//  QuotesOfAuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit

class QuotesOfAuthorVC: UIViewController {
    
    let quotesOfAuthorView: QuotesOfAuthorView = {
        let quotesOfAuthorView = QuotesOfAuthorView()
        return quotesOfAuthorView
    }()
    
    
    
    override func loadView() {
        super.loadView()
        view = quotesOfAuthorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCloseButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configCloseButton() {
        quotesOfAuthorView.closeButton.addTarget(self,
                                                 action: #selector(onCloseButton(sender:)),
                                                 for: .touchUpInside)
    }
    
    @objc func onCloseButton(sender: UIButton) {
        dismiss(animated: true)
    }
}
