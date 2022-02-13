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
    
    public private(set) var isConnected: Bool = false
    
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
}
