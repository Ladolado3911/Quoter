//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit

enum CellState {
    case on
    case off
}

class AuthorCell: UICollectionViewCell {
    
    var authorCellVM: AuthorCellVM?
    
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
        configCell()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    private func configCell() {
        guard let vm = authorCellVM else { return }
        
        switch vm.state {
        case .on:
            backgroundColor = .red
            // jazz
        case .off:
            backgroundColor = .blue
            // jazz
        }
    }
}
