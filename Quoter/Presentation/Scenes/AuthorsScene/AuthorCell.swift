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

//let compareImage: Data? = UIImage(named: "unknown")?.pngData()

class AuthorCell: UICollectionViewCell {
    
    var authorCellVM: AuthorCoreVM?
    var collectionViewHeight: CGFloat?
    var combineSubject: ((UIImage) -> Void)?
    
    var deleteGesture: (() -> Void)?
    
    var indexPath: IndexPath?
    
    var isInitialSetup = true
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let redView: UIView = {
        let redView = UIView()
        redView.backgroundColor = .red
        return redView
    }()
    
    lazy var overlayView: AuthorCellOverlayView = {
        let overlayView = AuthorCellOverlayView(frame: .zero, radius: imageView.layer.cornerRadius)
        overlayView.backgroundColor = .white
        return overlayView
    }()
    
    let deleteLabel: UILabel = {
        let deleteLabel = UILabel()
        deleteLabel.text = "Delete"
        deleteLabel.textAlignment = .center
        deleteLabel.textColor = .white
        deleteLabel.backgroundColor = .red
        return deleteLabel
    }()
    
    let selectTransform = CGAffineTransform(translationX: 0,
                                            y: -(20))
    
    lazy var onDeleteGestureRecognizer: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onDelete(sender:)))
        return tapGesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        redView.addGestureRecognizer(onDeleteGestureRecognizer)
//        layer.cornerRadius = 20
//        clipsToBounds = true
//        layer.masksToBounds = false
//        buildSubviews()
//        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
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
        redView.addSubview(deleteLabel)
        addSubview(redView)
        addSubview(overlayView)
        //bringSubviewToFront(overlayView)
//        redView.addGestureRecognizer(onDeleteGestureRecognizer)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        deleteLabel.snp.makeConstraints { make in
            make.left.right.equalTo(redView)
            make.centerY.equalTo(redView)
        }
        redView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(self.bounds.height * 0.2)
        }
        overlayView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(self.bounds.height * 0.2)
        }
    }
    
    private func setupCell() {
        guard let vm = authorCellVM else { return }
        guard collectionViewHeight != nil else { return  }

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
        if vm.isDefaultPicture {
            imageView.contentMode = .scaleAspectFit
            imageView.image = defaultImage
        }
        else {
            imageView.contentMode = .scaleAspectFill
            
            CoreDataManager.getAuthorImageAsync(author: vm) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let imageData):
                    if let imageData = imageData {
                        self.imageView.image = UIImage(data: imageData)
                    }
                    else {
                        print("could not unwrap image data")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        backgroundColor = .white
        
    }
    
    private func getNameFromUrl(urlString: String) -> String {
        let fullName = urlString.split(separator: "/").last!
        return String(fullName)
    }
    
    func switchCell() {
        guard let vm = authorCellVM else { return }
        guard collectionViewHeight != nil else { return  }

        setImage(vm: vm)
        
        switch vm.state {
        case .on:
            //print("up")
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.transform = self.selectTransform
                //self.imageView.layer.shadowOpacity = 1
                self.redView.transform = CGAffineTransform(translationX: 0, y: -self.redView.bounds.height)
                
            }
        case .off:
            if vm.isChanging! {
               // print("down")
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.transform = .identity
                    //self.imageView.layer.shadowOpacity = 0
                    self.redView.transform = .identity
                    
                }
                vm.isChanging = false
            }
        }
    }
    
    @objc func onDelete(sender: UITapGestureRecognizer) {
        print("delete author")
    }
}
