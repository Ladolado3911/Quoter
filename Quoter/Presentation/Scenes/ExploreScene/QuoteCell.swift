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
    var mainImage: UIImage?
    var imageType: ImageType?
    var isVCLoaded: Bool = false
    var isFirstAppear: Bool = true
    
    var tapOnBookGesture: UITapGestureRecognizer?

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
    
    private func getFontSizeForQuote(stringCount: CGFloat) -> CGFloat {
        let lowerBound: CGFloat = PublicConstants.screenHeight * 0.02159827213822894
        let higherBound: CGFloat = PublicConstants.screenHeight * 0.05399568034557235
        let boundRange = higherBound - lowerBound
        let testResult = lowerBound + ((1 / (stringCount / 35)) * boundRange)
        return testResult
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        guard let mainImage = mainImage else {
            return
        }
        guard let tapOnBookGesture = tapOnBookGesture else {
            return
        }

        
//        guard let mainImageURl = mainImageURL else {
//            return
//        }
        
        //print(quoteVM.content)
        
        quoteView.quoteViewButton.addGestureRecognizer(tapOnBookGesture)
        self.quoteView.mainImageView.image = mainImage
        self.quoteView.quoteTextView.text = quoteVM.content
        self.quoteView.authorLabel.text = quoteVM.authorName
        
        let fontSize = getFontSizeForQuote(stringCount: CGFloat(self.quoteView.quoteTextView.text?.count ?? 0))
        self.quoteView.quoteTextView.font = self.quoteView.quoteTextView.font?.withSize(fontSize)
        //quoteView.startAnimating()
//        quoteView.mainImageView.kf.setImage(with: mainImageURl) { [weak self] _ in
//            guard let self = self else { return }
//            self.quoteView.stopAnimating()
//            self.quoteView.quoteTextView.text = quoteVM.content
//            self.quoteView.authorLabel.text = quoteVM.authorName
//        }
        //quoteView.layoutIfNeeded()
    }

}
