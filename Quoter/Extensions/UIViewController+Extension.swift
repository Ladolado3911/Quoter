//
//  UIViewController+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

extension UIViewController {
    
    func presentPickModalAlert(title: String,
                               text: String,
                               mainButtonText: String,
                               mainButtonStyle: UIAlertAction.Style,
                               mainButtonAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true)
        }
        let mainAction = UIAlertAction(title: mainButtonText, style: mainButtonStyle) { _ in
            mainButtonAction()
        }
        alert.addAction(cancelAction)
        alert.addAction(mainAction)
        present(alert, animated: true)
    }
    
    func presentAlert(title: String,
                               text: String,
                               mainButtonText: String,
                               mainButtonStyle: UIAlertAction.Style,
                               mainButtonAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
        let mainAction = UIAlertAction(title: mainButtonText, style: mainButtonStyle) { _ in
            mainButtonAction()
        }
        alert.addAction(mainAction)
        present(alert, animated: true)
    }
}
