//
//  DeviceSelectVM.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceSelectVM: DeviceSelectVMProtocol {
    var nearbyState: DeviceSelectNearbyState = .ready([
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Near Item 1", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Near Item 2", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Near Item 3", details: "some"),
        ])
    var savedDevices: [DeviceSelectItem] = [
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 1", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 2", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3", details: "some"),
    ]
    
    func deleteSaved(index: Int) {
        savedDevices.remove(at: index)
    }
}

struct DeviceDummy: DeviceSelectItem {
    var icon: UIImage
    var name: String
    var details: String
}
