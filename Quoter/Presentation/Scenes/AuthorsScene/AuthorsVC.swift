//
//  ViewController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit
import Combine
import Kingfisher

let collectionViewUpdateSubject = PassthroughSubject<(() -> Void), Never>()

class AuthorsVC: UIViewController {

    var data3: [AuthorCoreVM] = []
    var selectedAuthor: AuthorCoreVM?
    var selectedIndexPath: IndexPath?
    
    var data3Before: [AuthorCoreVM] = []
    
    let compareImage = UIImage(named: "unknown")?.pngData()
    
    lazy var data3Subject = CurrentValueSubject<[AuthorCoreVM], Never>(data3)
    let mainImageSubject = CurrentValueSubject<UIImage, Never>(UIImage(named: "book")!)
    let mainTitle = CurrentValueSubject<String, Never>("Select Author")
    
    lazy var sendMainImagetoSubject: (UIImage) -> Void = { [weak self] image in
        guard let self = self else { return }
        self.mainImageSubject.send(image)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    let authorsView: AuthorsView = {
        let authorsView = AuthorsView()
        return authorsView
    }()
        
    override func loadView() {
        super.loadView()
        view = authorsView
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configButton()
        populateData()
        addListeners()
    }

    private func populateData() {
        if let authors = CoreDataManager.getAuthors() {
            var vms: [AuthorCoreVM] = []
            for vm in 0..<authors.count {
                let newVM = AuthorCoreVM(rootAuthor: authors[vm])
                if newVM.image.pngData() == compareImage {
                    newVM.isDefaultPicture = true
                }
                vms.append(newVM)
            }
//            print(vms.map { $0.name })
            data3 = vms
            data3Subject.send(data3)
            authorsView.authorsContentView.collectionView.reloadData()
        }
    }
    
    private func addListeners() {
        mainImageSubject
            .sink { [weak self] val in
                guard let self = self else { return }
                self.authorsView.mainImageView.image = val
            }
            .store(in: &cancellables)
        
        mainTitle
            .assign(to: \.text!, on: authorsView.quoterNameLabel)
            .store(in: &cancellables)
        
        data3Subject
            .map { vms in
                !vms.isEmpty
            }
            .assign(to: \.isHidden,
                    on: authorsView.authorsContentView.warningLabel)
            .store(in: &cancellables)
        
        collectionViewUpdateSubject
            .sink { [weak self] value in
                guard let self = self else { return }
                self.populateData()
            }
            .store(in: &cancellables)
    }

    private func configButton() {
        authorsView.authorsContentView.setQuoteButton.addTarget(self,
                                                                action: #selector(onSeeQuoteButton(sender:)),
                                                                for: .touchUpInside)
        data3Subject
            .map { vms in
                vms.map({ $0.state }).contains(.on) ? true : false
            }
            .assign(to: \.isButtonEnabled,
                    on: authorsView.authorsContentView.setQuoteButton)
            .store(in: &cancellables)
    }
    
    private func configCollectionView() {
        let collectionView = authorsView.authorsContentView.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuthorCell.self, forCellWithReuseIdentifier: "AuthorCell")
    }
    
    @objc func onSeeQuoteButton(sender: UIButton) {
        let vc = QuotesOfAuthorVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        guard let selectedAuthor = selectedAuthor else {
            return
        }
        vc.author = selectedAuthor
        vc.authorsVCreloadDataClosure = { [weak self] in
            if let selectedIndexPath = self?.selectedIndexPath {
                self?.data3.remove(at: selectedIndexPath.item)
                self?.authorsView.authorsContentView.collectionView.reloadData()
            }
        }
        present(vc, animated: true)
    }
    
    private func onDeleteView() {
        if let selectedAuthor = selectedAuthor,
           let selectedIndexPath = selectedIndexPath {
            print(selectedAuthor.name)
            CoreDataManager.deleteAuthor(authorName: selectedAuthor.name)
            data3.remove(at: selectedIndexPath.item)
            mainImageSubject.send(UIImage(named: "book")!)
            authorsView.mainImageView.contentMode = .scaleAspectFill
            mainTitle.send("Select Person")
            
            if !data3.isEmpty {
                data3[selectedIndexPath.item].turnOff(isChanging: true)
            }
            data3Subject.send(data3)
            authorsView.authorsContentView.collectionView.reloadData()
        }
    }
}

extension AuthorsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data3.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as? AuthorCell
        cell?.authorCellVM = data3[indexPath.item]
        cell?.collectionViewHeight = collectionView.bounds.height
        cell?.combineSubject = sendMainImagetoSubject
        cell?.indexPath = indexPath
        cell?.deleteClosure = { [weak self] in
            self?.onDeleteView()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: PublicConstants.screenWidth * 0.25,
               height: authorsView.authorsContentView.bounds.height * 0.322)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        PublicConstants.screenWidth * 0.04
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: collectionView.bounds.height - (authorsView.authorsContentView.bounds.height * 0.322),
                     left: PublicConstants.screenWidth * 0.04,
                     bottom: 0,
                     right: PublicConstants.screenWidth * 0.04)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemState = data3[indexPath.item].state
        let image = ((collectionView.cellForItem(at: indexPath) as? AuthorCell)?.imageView.image)!
        let name = data3[indexPath.item].name
        switch itemState {
        case .on:
            data3[indexPath.item].turnOff(isChanging: true)
            mainImageSubject.send(UIImage(named: "book")!)
            authorsView.mainImageView.contentMode = .scaleAspectFill
            mainTitle.send("Select Person")
        case .off:
            let filtered = data3.filter { $0 !== data3[indexPath.item] }
            for vm in 0...filtered.count {
                if data3[vm].state == .on {
                    selectedIndexPath = indexPath
                    selectedAuthor = data3[indexPath.item]
                    data3[vm].turnOff(isChanging: true)
                    data3[indexPath.item].turnOn()
                    if data3[indexPath.item].isDefaultPicture {
                        authorsView.mainImageView.contentMode = .scaleAspectFit
                    }
                    else {
                        authorsView.mainImageView.contentMode = .scaleAspectFill
                    }
                    data3Subject.send(data3)
                    mainImageSubject.send(image)
                    mainTitle.send(name)
                    return
                }
            }
            selectedIndexPath = indexPath
            selectedAuthor = data3[indexPath.item]
            data3[indexPath.item].turnOn()
            if data3[indexPath.item].isDefaultPicture {
                authorsView.mainImageView.contentMode = .scaleAspectFit
            }
            else {
                authorsView.mainImageView.contentMode = .scaleAspectFill
            }
            mainImageSubject.send(image)
            mainTitle.send(name)
        }
        data3Subject.send(data3)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? AuthorCell
        cell!.imageView.image = nil
        cell!.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? AuthorCell
        cell!.imageView.image = nil
        cell!.backgroundColor = .white
    }
}
