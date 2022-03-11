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

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
}
