//
//  Constants.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

struct Constants {
    
    struct WiFiLamp {
        
        static let defaultUsername = "admin"
        static let defaultPassword = "wifilamp"
        
        // swiftlint:disable:next force_https
        static let defaultTemporaryNetworkUrl = URL(string: "http://192.168.4.1")!
    }

    struct App {
        static let deeplinkScheme: String = "caveWifiLamp://"
        static let deviceDetailRegext: String = "^caveWifiLamp:\\/\\/\\?device=[a-zA-Z0-9]{1,}"
    }
}
