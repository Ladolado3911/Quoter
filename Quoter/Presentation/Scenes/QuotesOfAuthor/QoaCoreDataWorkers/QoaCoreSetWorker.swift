//
//  QoaCoreSetWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/7/22.
//

import UIKit

class QoaCoreSetWorker {
    
    func getInitialContent(author: AuthorCoreVM, defaultImage: UIImage?) -> (contentMode: UIView.ContentMode, isButtonEnabled: Bool) {
        
        var contentMode: UIView.ContentMode
        var isButtonEnabled: Bool = false
        
        if author.image.pngData() == defaultImage?.pngData() {
            contentMode = .scaleAspectFit
        }
        else {
            contentMode = .scaleAspectFill
        }
        if author.quotes.count > 1 {
            isButtonEnabled = true
            print("more than 1 qoute core")
        }
        return (contentMode, isButtonEnabled)
    }
    
    func getUpdatedContent(currentQuoteIndex: Int, quotesArr: [QuoteCore], networkArr: [QuoteGardenQuoteVM]) -> (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool) {
        
        var isNextButtonEnabled: Bool = !(currentQuoteIndex == quotesArr.count - 1)
        var isPrevButtonEnabled: Bool = false
        
        if currentQuoteIndex == quotesArr.count - 1 {
            isNextButtonEnabled = false
        }
        if currentQuoteIndex > 0 {
            isPrevButtonEnabled = true
        }
        if currentQuoteIndex == 0 {
            isPrevButtonEnabled = false
        }
        return (isNextButtonEnabled, isPrevButtonEnabled)
    }
}
