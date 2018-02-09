//
//  Defaults.swift
//  wifilamp
//
//  Created by Martin Púčik on 31/01/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit

class Defaults {

    private static let groupDefaults: UserDefaults = UserDefaults.init(suiteName: "group.com.strv.theCave.wifiLamp")!
    private static let savedDevicesKey = "savedDevicesKey"
    private static let savedCustomColorsKey = "savedCustomColorsKey"

    // MARK: - Saved devices
    static func savedDevices() -> [WiFiLamp] {
        guard let deviceData = groupDefaults.object(forKey: savedDevicesKey) as? Data,
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

        encodeAndSaveObject(allDevices, key: savedDevicesKey)
    }

    static func removeSavedDevice(_ device: WiFiLamp) {
        var allDevices = Defaults.savedDevices()
        if let foundIndex = allDevices.index(where: { $0.chipId == device.chipId }) {
            allDevices.remove(at: foundIndex)
        }

        encodeAndSaveObject(allDevices, key: savedDevicesKey)
    }

    static func deviceIsSaved(_ device: WiFiLamp) -> Bool {
        let allDevices = Defaults.savedDevices()
        return allDevices.contains(where: { $0.chipId == device.chipId })
    }

    // MARK: - Colors
    static func savedColors() -> [UIColor] {
        guard let colorsData = groupDefaults.object(forKey: savedCustomColorsKey) as? Data,
            let colorsCodes = try? JSONDecoder().decode([Int].self, from: colorsData) else { return [] }
        let colors = colorsCodes.map({ UIColor.init(hex: $0) })
        return colors
    }

    static func saveColor(_ color: UIColor) {
        var allColors = Defaults.savedColors()
        if !allColors.contains(where: { $0.isEqual(color) }) {
            // Color is not yet stored in all colors
            allColors.insert(color, at: 0)
        }

        let colorCodes = allColors.map({ $0.toHex() })
        encodeAndSaveObject(colorCodes, key: savedCustomColorsKey)
    }
}

private extension Defaults {
    static func encodeAndSaveObject<T: Encodable>(_ objectToSave: T, key: String) {
        do {
            let dataToSave = try JSONEncoder().encode(objectToSave)
            groupDefaults.set(dataToSave, forKey: key)
        } catch let error {
            debugPrint("Encoding object(\(objectToSave) for save failed: \(error)")
        }
    }
}
