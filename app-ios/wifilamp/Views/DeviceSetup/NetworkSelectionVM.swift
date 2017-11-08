//
//  NetworkSelectionVM.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

final class NetworkSelectionVM {
    var networks: [WiFiNetwork]
    
    init(networks: [WiFiNetwork]) {
        self.networks = networks
            .sorted { $0.signalStrength > $1.signalStrength }
            .filterDuplicates { $0.name == $1.name }
    }
}
