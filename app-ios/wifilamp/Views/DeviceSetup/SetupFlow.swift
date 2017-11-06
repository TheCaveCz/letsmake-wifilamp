//
//  SetupFlow.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Swinject
import PromiseKit

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
            let automaticSetupVC = self.createAutomaticSetupVC(for: device)
            vc.navigationController?.pushViewController(automaticSetupVC, animated: true)
        }
        
        return qrScannerVC
    }
    
    private func createAutomaticSetupVC(for device: Device) -> AutomaticSetupVC {
        let automaticSetupVC = self.resolver.resolve(AutomaticSetupVC.self, argument: device)!
        
        automaticSetupVC.actionAskToSelectNetworkToConnect = { vc, networks in
            return Promise { resolve, reject in
                let networkSelectionVC = self.createNetworkSelectionVC(for: networks)
                networkSelectionVC.actionNetworkSelected = { vc, selectedNetwork, passphase in
                    resolve((selectedNetwork, passphase))
                }
                networkSelectionVC.actionCancelled = { vc in
                    reject(DeviceSetupError.noNetworkSelected)
                }
                DispatchQueue.main.async {
                    vc.navigationController?.present(networkSelectionVC, animated: true, completion: nil)
                }
            }
        }
        
        return automaticSetupVC
    }
    
    private func createNetworkSelectionVC(for networks: [WiFiNetwork]) -> NetworkSelectionVC {
        let networkSelectionVC = self.resolver.resolve(NetworkSelectionVC.self, argument: networks)!
        return networkSelectionVC
    }
}
