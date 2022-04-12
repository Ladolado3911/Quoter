//
//  UIImage+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/16/22.
//

import UIKit

extension UIImage {
    
    func resizedImage(targetHeight: CGFloat) -> UIImage {
        let size = self.size

        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Return new image
        return newImage!
    }
    
}
