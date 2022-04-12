//
//  NetworkMonitor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/13/22.
//

import UIKit
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public var isFirstCheck: Bool = true
    
    public private(set) var isConnected: Bool = false
    
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(completion: @escaping (NWPath) -> Void) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if self.isFirstCheck {
                self.isConnected = path.status != .unsatisfied
            }
            else {
                self.isConnected = path.status == .unsatisfied
            }
            completion(path)

        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
}
