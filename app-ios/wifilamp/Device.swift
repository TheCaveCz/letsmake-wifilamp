//
//  Device.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol DeviceConvertible {
    
    func toDevice() -> Device
    
}


extension Device: DeviceConvertible {
    func toDevice() -> Device {
        return self
    }
}


extension BrowserRecord: DeviceConvertible {
    func toDevice() -> Device {
        return Device(baseUrl: url, name: name, chipId: chipId)
    }
}


struct Device {
    static let dummy = Device(baseUrl: URL(string:"http://foo")!, name: "Test", chipId: "edaded")
    
    let baseUrl: URL
    let name: String
    let chipId: String
    
    
}


