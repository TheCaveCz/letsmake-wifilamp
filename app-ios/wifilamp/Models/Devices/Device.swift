//
//  Device.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation
import PromiseKit

enum DeviceError: Error {
    case unknownDevice
}

enum DeviceSetupError: Error {
    case noNetworkSelected
}

protocol DeviceConvertible {
    func toDevice() -> Device
}

protocol DeviceSetupDelegate: class {
    func askUserToSelectWiFiNetwork(from: [WiFiNetwork]) -> Promise<(selectedNetwork: WiFiNetwork, passphase: String?)>
}

protocol Device {
    var localNetworkUrl: URL { get }
    var name: String { get }
    var chipId: String { get }
    
    func setup(progressUpdate: ((_ description: String, _ stepNumber: Int, _ totalSteps: Int) -> Void)?, delegate: DeviceSetupDelegate?) -> Promise<Void>
    func setColor(on deviceUrl: URL, _ red: CGFloat, _ blue: CGFloat, _ green: CGFloat) -> Promise<VoidResponse>
    func turn(on isOn: Bool, on deviceUrl: URL) -> Promise<VoidResponse>
}

struct UnknownDevice: Device {
    let chipId: String
    let name: String
    let localNetworkUrl: URL
    
    func setup(progressUpdate: ((String, Int, Int) -> Void)?, delegate: DeviceSetupDelegate?) -> Promise<Void> {
        return Promise(error: DeviceError.unknownDevice)
    }
    
    func setColor(on deviceUrl: URL, _ red: CGFloat, _ blue: CGFloat, _ green: CGFloat) -> Promise<VoidResponse> {
        return Promise(error: DeviceError.unknownDevice)
    }
    
    func turn(on isOn: Bool, on deviceUrl: URL) -> Promise<VoidResponse> {
        return Promise(error: DeviceError.unknownDevice)
    }

}
