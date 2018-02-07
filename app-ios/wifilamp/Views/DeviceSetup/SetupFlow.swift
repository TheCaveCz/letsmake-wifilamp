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
import SVProgressHUD

class SetupFlow: Flow {
    
    var flowCompletion: ((_ isSuccess: Bool) -> Void)?
    
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
                    vc.navigationController?.dismiss(animated: true, completion: nil)
                    resolve((selectedNetwork, passphase))
                }
                networkSelectionVC.actionCancelled = { vc in
                    vc.navigationController?.dismiss(animated: true, completion: nil)
                    reject(DeviceSetupError.noNetworkSelected)
                }
                DispatchQueue.main.async {
                    let navVC = CustomNavigationController(rootViewController: networkSelectionVC)
                    vc.navigationController?.present(navVC, animated: true, completion: nil)
                }
            }
        }
        
        automaticSetupVC.actionSetupFinished = { [weak self] vc, isSuccess in
            SVProgressHUD.showSuccess(withStatus: "Finished 🎉")
            SVProgressHUD.dismiss(withDelay: 1, completion: {
                vc.navigationController?.dismiss(animated: true, completion: nil)
                self?.flowCompletion?(isSuccess)
            })
        }
        
        return automaticSetupVC
    }
    
    private func createNetworkSelectionVC(for networks: [WiFiNetwork]) -> NetworkSelectionVC {
        let networkSelectionVC = self.resolver.resolve(NetworkSelectionVC.self, argument: networks)!
        return networkSelectionVC
    }
}
