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

protocol Device {
    var baseUrl: URL { get }
    var name: String { get }
    var chipId: String { get }
}

struct UnknownDevice: Device {
    let chipId: String
    let name: String
    let baseUrl: URL
}
