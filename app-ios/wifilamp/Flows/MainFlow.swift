//
//  MainFlow.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Swinject

protocol Flow {
    func createRootVC() -> UIViewController
    var flowCompletion: ((_ isSuccess: Bool) -> Void)? { get set }
}

class MainFlow: Flow {
    
    var flowCompletion: ((_ isSuccess: Bool) -> Void)?
    
    let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func createRootVC() -> UIViewController {
        let deviceController = resolver.resolve(DeviceSelectVC.self)!
        
        deviceController.actionSetupNewDevice = { controller in
            var flow = self.resolver.resolve(Flow.self, name: Flows.setup.rawValue)!
            flow.flowCompletion = { _ in
                self.resolver.resolve(Browser.self)?.refresh()
            }
            controller.navigationController?.present(flow.createRootVC(), animated: true, completion: nil)
        }
        
        deviceController.actionSelectDevice = { controller, item in
            guard let device = item as? DeviceConvertible else {
                print("Selected item \(item) is not DeviceConvertible")
                return
            }
            
            let flow = self.resolver.resolve(Flow.self, name: Flows.detail.rawValue, argument: device.toDevice())! //DeviceFlow(device: dc.toDevice())
            controller.navigationController?.pushViewController(flow.createRootVC(), animated: true)
        }
        
        return CustomNavigationController(rootViewController: deviceController)
    }
}
