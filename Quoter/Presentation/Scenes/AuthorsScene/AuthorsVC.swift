//
//  ViewController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit

class AuthorsVC: UIViewController {
    
    let data = [
        UIImage(named: "milne"),
        UIImage(named: "laozi"),
        UIImage(named: "gautama"),
        UIImage(named: "ralph")
    ]
    
    var data2 = Array(repeating: AuthorCellVM(state: .off, color: .blue) , count: 30)
    
    var data3 = [
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
        AuthorCellVM(state: .off, color: .blue),
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let authorsView: AuthorsView = {
        let authorsView = AuthorsView()
        return authorsView
    }()
    
    override func loadView() {
        super.loadView()
        view = authorsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
    }
    
    private func configCollectionView() {
        let collectionView = authorsView.authorsContentView.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuthorCell.self, forCellWithReuseIdentifier: "AuthorCell")
    }
}

extension AuthorsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //data.count
        //30
        data3.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as? AuthorCell
        //cell!.imageView.image = data[indexPath.item]
        cell?.authorCellVM = data3[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: PublicConstants.screenWidth * 0.25,
               height: authorsView.authorsContentView.bounds.height * 0.447)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        PublicConstants.screenWidth * 0.04
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: collectionView.bounds.height - (authorsView.authorsContentView.bounds.height * 0.447),
                     left: PublicConstants.screenWidth * 0.04,
                     bottom: 0,
                     right: PublicConstants.screenWidth * 0.04)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemState = data3[indexPath.item].state
        switch itemState {
        case .on:
            data3[indexPath.item].state = .off
        case .off:
            for vm in data3 {
                vm.state = .off
            }
            data3[indexPath.item].state = .on
        }
        collectionView.reloadData()
    }
}
