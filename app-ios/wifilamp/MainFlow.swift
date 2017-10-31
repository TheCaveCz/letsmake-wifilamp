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
}


class MainFlow: Flow {
    let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func createRootVC() -> UIViewController {
        let dc = resolver.resolve(DeviceSelectVC.self)!
        
        dc.actionSetupNewDevice = { vc in
            let flow = self.resolver.resolve(Flow.self, name: Flows.setup.rawValue)!
            vc.navigationController?.present(flow.createRootVC(), animated: true, completion: nil)
        }
        
        dc.actionSelectDevice = { vc, item in
            guard let dc = item as? DeviceConvertible else {
                print("Selected item \(item) is not DeviceConvertible")
                return
            }
            
            let flow = self.resolver.resolve(Flow.self, name: Flows.detail.rawValue, argument: dc.toDevice())! //DeviceFlow(device: dc.toDevice())
            vc.navigationController?.pushViewController(flow.createRootVC(), animated: true)
        }
        
        return CustomNavigationController(rootViewController: dc)
    }
    
}
