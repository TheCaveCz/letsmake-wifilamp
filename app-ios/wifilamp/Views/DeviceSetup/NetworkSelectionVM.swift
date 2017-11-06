//
//  NetworkSelectionVM.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

final class NetworkSelectionVM {
    private let allNetworks: [WiFiNetwork]
    
    init(networks: [WiFiNetwork]) {
        self.allNetworks = networks
    }
}
