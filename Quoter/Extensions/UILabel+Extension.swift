//
//  UILabel+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/16/22.
//

import UIKit

extension UILabel {
    
    func addLineHeight(lineHeight: CGFloat) {
        let textForLabel = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        //paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.minimumLineHeight = lineHeight
        let attrString = NSMutableAttributedString(string: text ?? "No Text")
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
        //self.textAlignment = NSTextAlignment.Center
    }
    
}
