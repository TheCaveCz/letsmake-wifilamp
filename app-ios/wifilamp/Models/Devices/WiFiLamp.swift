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

extension WiFiLamp: BrowserRecord {
    var identifier: String { return chipId }
}

struct WiFiLampBrowserFactory {
    static let removedPrefix = "The Cave "
    static let chipIdRegex = try? NSRegularExpression(pattern: "^wifilamp-([0-9a-f]{6})\\.local\\.$", options: [])
    
    static func from(service: NetService) -> WiFiLamp? {
        // swiftlint:disable:next force_https
        guard let data = service.txtRecordData(), let hostName = service.hostName, let url = URL(string: "http://\(hostName)"), service.port == 80 else {
            return nil
        }
        
        let chipId: String
        if let chipIdData = NetService.dictionary(fromTXTRecord: data)["chipid"], let txtChipId = String(data: chipIdData, encoding: .utf8) {
            chipId = txtChipId
        } else if let match = chipIdRegex?.firstMatch(in: hostName, options: [], range: NSRange(location: 0, length: hostName.count)) {
            chipId = (hostName as NSString).substring(with: match.range(at: 1))
        } else {
            return nil
        }
        
        
        var name = service.name
        if name.hasPrefix(removedPrefix) {
            name.removeFirst(removedPrefix.count)
        }
        
        return WiFiLamp(chipId: chipId, name: name,localNetworkUrl: url)
    }
    
    static func browser() -> Browser {
        return Browser(converter: from)
    }
}
