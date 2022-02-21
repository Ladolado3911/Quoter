//
//  QuoteCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/20/22.
//

import UIKit
import SnapKit


class QuoteCell: UICollectionViewCell {
    
    let quoteView: QuoteView = {
        let quoteView = QuoteView()
        return quoteView
    }()
    
    var quoteVM: QuoteGardenQuoteVM? {
        didSet {
            configWithVM()
        }
    }
    var mainImageURL: URL?
    var imageType: ImageType?
    var isVCLoaded: Bool = false
    var isFirstAppear: Bool = true

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(quoteView)
        quoteView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        configWithVM()
//        if isFirstAppear {
//            isFirstAppear = false
//        }
//        else {
//            if quoteView.lottieAnimation.isAnimationPlaying {
//                quoteView.stopAnimating()
//                quoteView.startAnimating()
//            }
//        }
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        guard let mainImageURl = mainImageURL else {
            return
        }
        
        print(quoteVM.content)
        
        //quoteView.quoteViewButton.addGestureRecognizer(tapOnBookGesture)
        quoteView.startAnimating()
        quoteView.mainImageView.kf.setImage(with: mainImageURl) { [weak self] _ in
            guard let self = self else { return }
            self.quoteView.stopAnimating()
            self.quoteView.quoteTextView.text = quoteVM.content
            self.quoteView.authorLabel.text = quoteVM.authorName
        }
        quoteView.layoutIfNeeded()
    }

}
