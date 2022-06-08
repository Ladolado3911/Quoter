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
    
    //var startY: CGFloat?
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func loadView() {
        super.loadView()
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
        let translation = sender.translation(in: filterView)
        let minY = self.filterView.frame.minY
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        self.filterView.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: filterView)
            if dragVelocity.y >= 1300 {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    self.filterView.frame.origin = CGPoint(x: 0, y: Constants.screenHeight)
                } completion: { didFinish in
                    if didFinish {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else if minY >= Constants.screenHeight * 0.55  {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    self.filterView.frame.origin = CGPoint(x: 0, y: Constants.screenHeight)
                } completion: { didFinish in
                    if didFinish {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    self.filterView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: self.view.bounds.height * 0.8169)
                }
            }
        }
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
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.view.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.filterView.transform = transform
            }
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.pointOrigin = self.filterView.frame.origin
            }
        }
    }

    private func hideView() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.filterView.transform = .identity
        }
    }
    
}

extension FilterVC: FilterVCProtocol {
    
}
