//
//  BookImageView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

class BookImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        image = UIImage(named: "Reading")
        isUserInteractionEnabled = true
    }
}
