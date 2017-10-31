//
//  SetupFlow.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Swinject

class SetupFlow: Flow {
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func createRootVC() -> UIViewController {
        let initialVC = createQRScannerVC()
        return CustomNavigationController(rootViewController: initialVC)
    }
    
    func createQRScannerVC() -> UIViewController {
        let qrScannerVC = resolver.resolve(QRScannerVC.self)!
        return qrScannerVC
    }
}
