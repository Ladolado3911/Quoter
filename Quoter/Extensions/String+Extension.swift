//
//  String+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

extension String {
    
    func convertAuthorNameException() -> String {
        var newSlug: String = ""
        if self == "Napoleon_Bonaparte" {
            newSlug = "Napoleon"
        }
        else if self == "Buddha" {
            newSlug = "Gautama_Buddha"
        }
        else if self == "Bernard_Shaw" {
            newSlug = "George_Bernard_Shaw"
        }
        else {
            newSlug = self
        }
        return newSlug
    }
}
