//
//  WiFiNetworkProtocol.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol WiFiNetwork {
    /**
     SSID of the WiFi network
     */
    var name: String { get }
    
    /**
     Received signal strength indication (RSSI).
     Represented in a negative form, the closer the value is to 0, the stronger the received signal has been.
     */
    var signalStrength: Int { get }
    
    /**
     True if needs passphase to connect.
     */
    var isPasswordProtected: Bool { get }
}
