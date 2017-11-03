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

protocol DeviceConvertible {
    func toDevice() -> Device
}

protocol Device {
    var baseUrl: URL { get }
    var name: String { get }
    var chipId: String { get }
    func setup(progressUpdate: ((_ description: String, _ stepNumber: Int, _ totalSteps: Int) -> Void)?) -> Promise<Void>
}

struct UnknownDevice: Device {
    let chipId: String
    let name: String
    let baseUrl: URL
    func setup(progressUpdate: ((String, Int, Int) -> Void)?) -> Promise<Void> {
        return Promise(error: DeviceError.unknownDevice)
    }
}
