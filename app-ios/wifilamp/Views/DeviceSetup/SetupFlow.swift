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
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func createRootVC() -> UIViewController {
        let initialVC = createQRScannerVC()
        return CustomNavigationController(rootViewController: initialVC)
    }
    
    private func createQRScannerVC() -> QRScannerVC {
        let qrScannerVC = resolver.resolve(QRScannerVC.self)!
        
        qrScannerVC.actionScannedDevice = { vc, device in
            let automaticSetupVC = self.resolver.resolve(AutomaticSetupVC.self, argument: device)!
            vc.navigationController?.pushViewController(automaticSetupVC, animated: true)
        }
        
        return qrScannerVC
    }
}
