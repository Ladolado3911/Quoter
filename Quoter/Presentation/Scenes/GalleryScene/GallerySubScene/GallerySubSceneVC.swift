//
//  GallerySubSceneVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/16/22.
//

import UIKit
import SDWebImage

class GallerySubSceneVC: UIViewController {
    
    var quoteContent: String?
    var authorName: String?
    var imageURLString: String?
    
    lazy var galleryQuoteView: GalleryQuoteView = {
        let quoteView = GalleryQuoteView(frame: view.initialFrame)
        if let quoteContent = quoteContent,
           let authorName = authorName,
           let imageURLString = imageURLString {
            quoteView.quoteContentLabel.text = quoteContent
            quoteView.authorNameLabel.text = authorName
            quoteView.imgView.sd_setImage(with: URL(string: imageURLString))
        }
        return quoteView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.masksToBounds = true
        view.addSubview(galleryQuoteView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configButtons()
        showView()
    }
    
    private func configButtons() {
        galleryQuoteView.closeButton.addTarget(self, action: #selector(didTapOnCloseButton), for: .touchUpInside)
    }
    
    private func showView() {
        let finalFrame = CGRect(x: 30,
                                y: 100,
                                width: Constants.screenWidth - 60,
                                height: Constants.screenHeight - 200)
        let finalFrameForImgView = CGRect(x: 0,
                                          y: 0,
                                          width: Constants.screenWidth - 60,
                                          height: Constants.screenHeight - 200)
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.galleryQuoteView.frame = finalFrame
            self.galleryQuoteView.imgView.frame = finalFrameForImgView
            self.galleryQuoteView.gradientLayer.frame = finalFrameForImgView
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.galleryQuoteView.layer.borderWidth = 1
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.galleryQuoteView.quoteContentLabel.alpha = 1
                    self.galleryQuoteView.authorNameLabel.alpha = 1
                    self.galleryQuoteView.closeButton.alpha = 1
                    self.galleryQuoteView.quotieLogoImageView.alpha = 1
                }
            }
        }
    }
    
    private func hideView() {
        self.galleryQuoteView.layer.borderWidth = 0
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.galleryQuoteView.quoteContentLabel.alpha = 0
            self.galleryQuoteView.authorNameLabel.alpha = 0
            self.galleryQuoteView.closeButton.alpha = 0
            self.galleryQuoteView.quotieLogoImageView.alpha = 0
        } completion: { didFinish in
            if didFinish {
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    guard let self = self else { return }
                    self.galleryQuoteView.alpha = 0
                } completion: { [weak self] didFinish in
                    if didFinish {
                        guard let self = self else { return }
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}

extension GallerySubSceneVC {
    @objc func didTapOnCloseButton() {
        hideView()
    }
}
