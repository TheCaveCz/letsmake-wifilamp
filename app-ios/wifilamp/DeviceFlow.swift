//
//  DeviceFlow.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceFlow: Flow {
    var flowCompletion: ((_ isSuccess: Bool) -> Void)?
    
    let device: Device
    
    init(device: Device) {
        self.device = device
    }
    
    func createRootVC() -> UIViewController {
        let vc = R.storyboard.main.deviceDetailVC()!
        vc.viewModel = DeviceDetailVM(device: device)
        return vc
    }
}
