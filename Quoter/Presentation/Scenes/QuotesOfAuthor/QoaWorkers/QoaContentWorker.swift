//
//  QoaContentWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

class QoaContentWorker {
    
    let networkWorker = QoaNetworkWorker()
    let coreDataWorker = QoaCoreDataWorker()
    
    func getContent(state: QuotesOfAuthorVCState) {
        switch state {
        case .network:
            networkWorker.getNetworkData()
        case .coreData:
            coreDataWorker.getCoreData()
        }
    }
    
}
