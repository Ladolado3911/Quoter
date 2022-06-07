//
//  FilterVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterVCProtocol {
    var interactor: FilterInteractorProtocol? { get set }
    var router: FilterRouterProtocol? { get set }
    
  
}

class FilterVC: UIViewController {
    var interactor: FilterInteractorProtocol?
    var router: FilterRouterProtocol?
    
    lazy var filterView: FilterView = {
        let frame = CGRect(x: 0,
                           y: view.bounds.height,
                           width: view.bounds.width,
                           height: view.bounds.height * 0.8169)
        let filter = FilterView(frame: frame)
        return filter
    }()
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panFunc))
        return gesture
    }()
    
    var startY: CGFloat?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterView.addGestureRecognizer(panGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildSubviews()
        showView()
    }
    
    @objc func panFunc(sender: UIPanGestureRecognizer) {
        guard let startY = startY else {
            return
        }
        let velocityY = sender.velocity(in: filterView).y
        if abs(velocityY) > 3000 {
            return
        }
        let translationY = sender.translation(in: filterView).y
        print("frame: \(filterView.frame.minY)")
        print("start: \(startY)")
        print("velocity: \(velocityY)")
        if filterView.frame.minY == startY && velocityY < 0 {
            return
        }
        
        
        //print(velocityY)
        filterView.frame = CGRect(x: 0,
                                  y: startY + translationY,
                                  width: filterView.bounds.width,
                                  height: filterView.bounds.height)
        
    }
    
    private func setup() {
        let vc = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
        let exploreNetworkWorker = ExploreNetworkWorker()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func buildSubviews() {
        view.addSubview(filterView)
        view.bringSubviewToFront(filterView)
    }
    
    private func showView() {
        let transform = CGAffineTransform(translationX: 0, y: -filterView.bounds.height)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromTop]) { [weak self] in
            guard let self = self else { return }
            self.filterView.transform = transform
        } completion: { didFinish in
            if didFinish {
                self.startY = self.filterView.frame.minY
            }
        }

    }
    
    private func hideView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.filterView.transform = .identity
        }
    }
    
}

extension FilterVC: FilterVCProtocol {
    
}
