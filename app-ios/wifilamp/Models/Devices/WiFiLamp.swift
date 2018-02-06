//
//  WiFiLamp.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

class WiFiLamp: Codable {
    let chipId: String
    var name: String
    let localNetworkUrl: URL
    
    init(chipId: String, name: String? = nil, localNetworkUrl: URL? = nil) {
        self.chipId = chipId
        self.name = name ?? "WiFi lamp (\(chipId))"
        // swiftlint:disable:next force_https
        self.localNetworkUrl = localNetworkUrl ?? URL(string: "http://wifilamp-\(chipId).local")!
    }

    enum CodingKeys: CodingKey {
        case chipId
        case name
        case localNetworkUrl
    }

    // MARK: - Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chipId, forKey: WiFiLamp.CodingKeys.chipId)
        try container.encode(name, forKey: WiFiLamp.CodingKeys.name)
        try container.encode(localNetworkUrl, forKey: WiFiLamp.CodingKeys.localNetworkUrl)
    }
}
