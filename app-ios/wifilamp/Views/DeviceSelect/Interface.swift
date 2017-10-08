//
//  DeviceSelectInterface.swift
//  wifilamp
//
//  Created by Džindra on 08/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


protocol DeviceSelectItem {
    var icon: UIImage { get }
    var name: String { get }
    var details: String { get }
}


enum DeviceSelectNearbyState {
    case empty
    case loading
    case ready([DeviceSelectItem])
}


protocol DeviceSelectVMProtocol {
    var nearbyState: DeviceSelectNearbyState { get }
    var savedDevices: [DeviceSelectItem] { get }
    
    func deleteSaved(index: Int)
}
