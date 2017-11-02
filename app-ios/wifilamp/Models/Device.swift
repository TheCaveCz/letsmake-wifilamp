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
    func setup(
        success: @escaping (() -> Void),
        failure: @escaping ((Error) -> Void),
        progressUpdate: ((_ description: String, _ stepNumber: Int, _ totalSteps: Int) -> Void)?
    )
}

struct UnknownDevice: Device {
    let chipId: String
    let name: String
    let baseUrl: URL
    func setup(success: @escaping (() -> Void), failure: @escaping ((Error) -> Void), progressUpdate: ((String, Int, Int) -> Void)?) {
        // TODO: call failure() with an error
    }
}
