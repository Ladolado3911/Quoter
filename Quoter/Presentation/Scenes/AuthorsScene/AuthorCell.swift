//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit
import Combine

enum CellState {
    case on
    case off
}

class AuthorCell: UICollectionViewCell {
    
    var authorCellVM: AuthorCellVM? 
    var collectionViewHeight: CGFloat?
    
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
                                                y: -(collectionViewHeight - bounds.height))

        imageView.image = vm.image
        
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
    
    func switchCell() {
        guard let vm = authorCellVM else { return }
        guard let collectionViewHeight = collectionViewHeight else { return  }

        let selectTransform = CGAffineTransform(translationX: 0,
                                                y: -(collectionViewHeight - bounds.height))

        imageView.image = vm.image
        
        
        switch vm.state {
        case .on:
            print("up")
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.transform = selectTransform
            }
        case .off:
            if vm.isChanging! {
                print("down")
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.transform = .identity
                }
                vm.isChanging = false
            }
        }
    }
}
