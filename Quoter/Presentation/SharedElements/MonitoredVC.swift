//
//  MonitoredViewController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/14/22.
//

import UIKit
import Combine
import Network

class MonitoredVC: UIViewController {
    
    let connectionStatusSubject = PassthroughSubject<(Bool, Bool), Never>()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkMonitor.shared.startMonitoring { [weak self] path in
//            if NetworkMonitor.shared.isFirstCheck {
//                self?.connectionStatusSubject.send(path.status != .unsatisfied)
//                NetworkMonitor.shared.isFirstCheck = false
//            }
//            else {
//                self?.connectionStatusSubject.send(path.status == .unsatisfied)
//            }
//        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NetworkMonitor.shared.startMonitoring { [weak self] path in
//            if NetworkMonitor.shared.isFirstCheck {
//                self?.connectionStatusSubject.send(path.status != .unsatisfied)
//                NetworkMonitor.shared.isFirstCheck = false
//            }
//            else {
//                self?.connectionStatusSubject.send(path.status == .unsatisfied)
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NetworkMonitor.shared.stopMonitoring()
//        cancellables.forEach { cancellable in
//            cancellable.cancel()
//        }
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
}
