//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit
import Combine
import Kingfisher

enum CellState {
    case on
    case off
}

class AuthorCell: UICollectionViewCell {
    
    var authorCellVM: AuthorCoreVM?
    var collectionViewHeight: CGFloat?
    var combineSubject: ((UIImage) -> Void)?
    
    var isInitialSetup = true
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        clipsToBounds = true
        layer.masksToBounds = false
        buildSubviews()
        buildConstraints()
        if isInitialSetup {
            setupCell()
        }
        else {
            switchCell()
        }
        isInitialSetup = false
    }
    
    private func buildSubviews() {
        addSubview(imageView)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    private func setupCell() {
        guard let vm = authorCellVM else { return }
        guard let collectionViewHeight = collectionViewHeight else { return  }

        let selectTransform = CGAffineTransform(translationX: 0,
                                                y: -(20))
        
        self.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0,
                                         height: 13)

        //imageView.image = vm.image
        
        setImage(vm: vm)

        switch vm.state {
        case .on:
            if isInitialSetup {
                transform = selectTransform
                return
            }
            
        case .off:
            if isInitialSetup {
                transform = .identity
                return
            }
        }
    }
    
    private func setImage(vm: AuthorCoreVM) {
        imageView.image = vm.image
        backgroundColor = .white
    }
    
//    private func setImage(vm: AuthorCoreVM) {
//        let name = self.getNameFromUrl(urlString: vm.link)
//        let url = QuoteEndpoints.getAuthorImageURL(authorName: name)!
//        NetworkManager.getData(url: url,
//                               model: Resource(model: Response.self)) { result in
//            switch result {
//            case .success(let response):
//                if let thumbnail = response.query?.pages?.first!.thumbnail {
//                    let urlString = thumbnail.source
//                    let url = URL(string: urlString!)!
//                    DispatchQueue.main.async {
//                        self.imageView.kf.setImage(with: url)
//                        self.backgroundColor = .white
////                        if let combineSubject = self.combineSubject {
////                            let resource = ImageResource(downloadURL: url)
////                            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
////                                switch result {
////                                case .success(let value):
////                                    combineSubject(value.image)
////                                case .failure(let error):
////                                    print("Error: \(error)")
////                                }
////                            }
////                        }
//                    }
//                }
//                else {
//                    self.imageView.image = UIImage(named: "unknown")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    private func getNameFromUrl(urlString: String) -> String {
        let fullName = urlString.split(separator: "/").last!
        return String(fullName)
    }
    
    func switchCell() {
        guard let vm = authorCellVM else { return }
        guard let collectionViewHeight = collectionViewHeight else { return  }

        let selectTransform = CGAffineTransform(translationX: 0,
                                                y: -(20))

        setImage(vm: vm)
        
        switch vm.state {
        case .on:
            print("up")
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.transform = selectTransform
                self.layer.shadowOpacity = 1
            }
        case .off:
            if vm.isChanging! {
                print("down")
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.transform = .identity
                    self.layer.shadowOpacity = 0
                }
                vm.isChanging = false
            }
        }
    }
}
