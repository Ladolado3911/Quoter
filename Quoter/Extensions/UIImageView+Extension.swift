//
//  UIImageView+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/10/22.
//

import UIKit

extension UIImageView {

    var intrSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
