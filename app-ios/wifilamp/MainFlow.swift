//
//  MainFlow.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit



class MainFlow: Flow {
    let context: Context
    

    init(context: Context) {
        self.context = context
        
        context.browser.startSearch()
    }
    
    func createRootVC() -> UIViewController {
        let dc = R.storyboard.main.instantiateInitialViewController()!
        dc.viewModel = DeviceSelectVM(browser: context.browser)
        
        dc.actionAddDevice = { vc in
            print("Add")
        }
        dc.actionSelectDevice = { vc, item in
            guard let dc = item as? DeviceConvertible else {
                print("Selected item \(item) is not DeviceConvertible")
                return
            }
            
            let flow = DeviceFlow(device: dc.toDevice())
            vc.navigationController?.pushViewController(flow.createRootVC(), animated: true)
        }
        
        return CustomNavigationController(rootViewController: dc)
    }
    
}
