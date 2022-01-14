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
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as? AuthorCell
        cell!.imageView.image = data[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: PublicConstants.screenWidth * 0.25,
               height: authorsView.authorsContentView.bounds.height * 0.447)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
