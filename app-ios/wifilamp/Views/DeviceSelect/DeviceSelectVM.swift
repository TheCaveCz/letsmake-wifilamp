//
//  DeviceSelectVM.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


protocol DeviceSelectVMDelegate: class {
    func nearbyDevicesChanged()
    func allDevicesChanged()
}

class DeviceSelectVM {
    private let browser: Browser
    weak var delegate: DeviceSelectVMDelegate?
    
    var nearbyDevices: [DeviceSelectItem] {
        let saved = savedDevices
        
        return browser.records.compactMap { $0 as? DeviceSelectItem }.filter {
            device in !saved.contains { $0.identifier == device.identifier }
        }
    }
    
    var savedDevices: [DeviceSelectItem] {
        return Defaults.savedDevices()
    }

    var isLookingForNearby: Bool {
        return browser.searching
    }
    
    init(browser: Browser) {
        self.browser = browser
        browser.delegate = self
    }

    // TODO : use some kind of Saveable protocol
    func saveNearbyDevice(index: Int) {
        guard index < nearbyDevices.count, let device = nearbyDevices[index] as? WiFiLamp else { return }
        Defaults.saveDevice(device)
        delegate?.allDevicesChanged()
    }

    func deleteSaved(index: Int) {
        guard index < savedDevices.count, let device = savedDevices[index] as? WiFiLamp else { return }
        Defaults.removeSavedDevice(device)
        delegate?.allDevicesChanged()
    }

    func refresh() {
        browser.refresh()
    }
}

extension DeviceSelectVM: BrowserDelegate {
    func browserStartedSearching(_ browser: Browser) {
        delegate?.nearbyDevicesChanged()
    }

    func browser(_ browser: Browser, foundRecord record: BrowserRecord) {
        delegate?.nearbyDevicesChanged()
    }
    
    func browser(_ browser: Browser, removedRecord record: BrowserRecord) {
        delegate?.nearbyDevicesChanged()
    }
}
