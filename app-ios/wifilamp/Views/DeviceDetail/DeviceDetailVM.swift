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
    
    let colors: [UIColor] = [
        UIColor(red: 1,        green: 0x69/255, blue: 0,        alpha: 1),
        UIColor(red: 0xff/255, green: 189/255,  blue: 0,        alpha: 1),
        UIColor(red: 142/255,  green: 255/255,  blue: 210/255,  alpha: 1),
        UIColor(red: 0,        green: 0xd0/255, blue: 0x84/255, alpha: 1),
        UIColor(red: 0x8e/255, green: 0xd1/255, blue: 0xfc/255, alpha: 1),
        UIColor(red: 0x06/255, green: 0x93/255, blue: 0xe3/255, alpha: 1),
        UIColor(red: 0xab/255, green: 0xb8/255, blue: 0xc3/255, alpha: 1),
        UIColor(red: 0xeb/255, green: 0x14/255, blue: 0x4c/255, alpha: 1),
        UIColor(red: 0xf7/255, green: 0x8d/255, blue: 0xa7/255, alpha: 1),
        UIColor(red: 0x99/255, green: 0,        blue: 0xef/255, alpha: 1),
        UIColor(red: 1,        green: 1,        blue: 1,        alpha: 1),
        UIColor(red: 0.5,      green: 0.5,      blue: 0.5,      alpha: 1),
    ]
    
    init(device: Device) {
        self.device = device
        
        
    }
    
}
