//
//  Defaults.swift
//  wifilamp
//
//  Created by Martin Púčik on 31/01/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import Foundation

class Defaults {

    private static let savedDevicesKey = "savedDevicesKey"

    // MARK: - Saved devices
    static func savedDevices() -> [WiFiLamp] {
        guard let deviceData = UserDefaults.standard.object(forKey: savedDevicesKey) as? Data,
            let devices = try? JSONDecoder().decode([WiFiLamp].self, from: deviceData) else { return [] }
        return devices
    }

    static func saveDevice(_ device: WiFiLamp) {
        var allDevices = Defaults.savedDevices()
        
        if let foundIndex = allDevices.index(where: { $0.chipId == device.chipId }),
            let range = Range<Int>.init(NSRange.init(location: foundIndex, length: 1)) {
            // Device with chipId already saved, update device
            allDevices.replaceSubrange(range, with: [device])
        } else {
            // Device is not yet in all devices
            allDevices.append(device)
        }

        do {
            let devicesData = try JSONEncoder().encode(allDevices)
            UserDefaults.standard.set(devicesData, forKey: savedDevicesKey)
        } catch let error {
            debugPrint("Encoding all saved devices failed: \(error)")
        }
    }
}
