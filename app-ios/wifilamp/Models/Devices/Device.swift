//
//  Device.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation
import PromiseKit


enum DeviceSetupError: Error {
    case noNetworkSelected
}

protocol DeviceSetupDelegate: class {
    func askUserToSelectWiFiNetwork(from: [WiFiNetwork]) -> Promise<(selectedNetwork: WiFiNetwork, passphase: String?)>
}

protocol Device {
    var localNetworkUrl: URL { get }
    var name: String { get }
    var chipId: String { get }
    
    func setup(progressUpdate: ((_ description: String, _ stepNumber: Int, _ totalSteps: Int) -> Void)?, delegate: DeviceSetupDelegate?) -> Promise<Void>
    func setColor(on deviceUrl: URL, _ red: Int, _ blue: Int, _ green: Int) -> Promise<VoidResponse>
    func turn(on isOn: Bool, on deviceUrl: URL) -> Promise<VoidResponse>
}
