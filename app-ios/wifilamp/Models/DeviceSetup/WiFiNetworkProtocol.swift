//
//  WiFiNetworkProtocol.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol WiFiNetwork {
    var name: String { get }
    var signalStrength: Int { get }
    var isPasswordProtected: Bool { get }
}
