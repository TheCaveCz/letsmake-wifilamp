//
//  DeviceSelectItem.swift
//  wifilamp
//
//  Created by Džindra on 07/04/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit

protocol DeviceSelectItem {
    var icon: UIImage { get }
    var name: String { get }
    var details: String { get }
    var identifier: String { get }
}

extension WiFiLamp: DeviceSelectItem {
    var icon: UIImage {
        return R.image.lampOff()!
    }
    
    var details: String {
        return "ID: \(chipId)"
    }
}
