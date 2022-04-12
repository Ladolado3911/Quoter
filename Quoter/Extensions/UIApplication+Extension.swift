//
//  UIApplication+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/17/22.
//

import UIKit

extension UIApplication {
    
    static func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }
        else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}
