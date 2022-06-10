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
