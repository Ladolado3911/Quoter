//
//  String+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

extension String {
    
    var isValidEmail: (String, Bool) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let bool = emailPred.evaluate(with: self)
        let str = bool ? "" : "Email is not valid"
        return (str, bool)
    }
    
    var isValidPassword: (String, Bool) {
        // Minimum 8 characters at least 1 Alphabet and 1 Number
        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let bool = passwordPred.evaluate(with: self)
        let str = bool ? "" : "Minimum 8 characters, at least one letter and one number"
        return (str, bool)
    }
    
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
    
    func convertAuthorName() -> String {
        self.replacingOccurrences(of: " ", with: "_")
    }
    
    func getNeededIcon() -> UIImage? {
        switch self {
        case "rich":
            return FilterIcons.billionairesIcon
        case "artists":
            return FilterIcons.artIcon
        case "sportsmen":
            return FilterIcons.cupIcon
        case "politicians":
            return FilterIcons.politicIcon
        case "ancients":
            return FilterIcons.ancientIcon
        case "actors":
            return FilterIcons.actorIcon
        case "writers":
            return FilterIcons.writeIcon
        case "scientists":
            return FilterIcons.scienceIcon
        default:
            return nil
        }
        
    }
}
