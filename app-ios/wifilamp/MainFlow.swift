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
        let dc = resolver.resolve(DeviceSelectVC.self)!
        
        dc.actionSetupNewDevice = { vc in
            var flow = self.resolver.resolve(Flow.self, name: Flows.setup.rawValue)!
            flow.flowCompletion = { _ in
                self.resolver.resolve(Browser.self)?.refresh()
            }
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
