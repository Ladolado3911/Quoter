//
//  QoaNetworkSetWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/7/22.
//

import UIKit

class QoaNetworkSetWorker {
    
    func getContent(defaultImage: UIImage?,
                    networkAuthorImage: UIImage?,
                    networkArray: [QuoteGardenQuoteVM]) -> (contentMode: UIView.ContentMode, exportImage: UIImage?, isButtonEnabled: Bool) {
        
        var contentMode: UIView.ContentMode
        var exportImage: UIImage?
        var isButtonEnabled: Bool = false
        
        if networkAuthorImage == nil {
            contentMode = .scaleAspectFit
            exportImage = defaultImage
        }
        else {
            contentMode = .scaleAspectFill
            exportImage = networkAuthorImage
        }
        if networkArray.count > 1 {
            print("more than 1 qoute network")
            isButtonEnabled = true
        }
        return (contentMode, exportImage, isButtonEnabled)
    }
    
}
