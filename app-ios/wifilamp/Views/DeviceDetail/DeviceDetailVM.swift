//
//  DeviceDetailVM.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceDetailVM {
    private let device: Device
    
    var title: String {
        return device.name
    }
    
    let colors: [UIColor] = [.gray, .red, .blue, .green, .yellow, .white, .black, .cyan, .magenta, .orange]
    
    init(device: Device) {
        self.device = device
    }
    
}
