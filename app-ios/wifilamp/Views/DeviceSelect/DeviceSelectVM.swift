//
//  DeviceSelectVM.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

protocol DeviceSelectItem {
    var icon: UIImage { get }
    var name: String { get }
    var details: String { get }
}

protocol DeviceSelectVMDelegate: class {
    func nearbyDevicesChanged()
}

class DeviceSelectVM {
    private let browser: Browser
    weak var delegate: DeviceSelectVMDelegate?
    
    var nearbyDevices: [DeviceSelectItem] {
        return browser.records.filter({ device -> Bool in
            return savedDevices.contains(where: { savedDevice -> Bool in
                guard let saved = savedDevice as? WiFiLamp else { return false }
                return saved.chipId != device.chipId
            })
        })
    }
    
    var savedDevices: [DeviceSelectItem] = {
        return Defaults.savedDevices()
    }()

    var isLookingForNearby: Bool {
        return browser.searching
    }
    
    init(browser: Browser) {
        self.browser = browser
        browser.delegate = self
    }

    func saveNearbyDevice(index: Int) {
        guard index < nearbyDevices.count, let device = nearbyDevices[index] as? WiFiLamp else { return }
        Defaults.saveDevice(device)
    }

    func deleteSaved(index: Int) {
        guard index < savedDevices.count, let device = savedDevices[index] as? WiFiLamp else { return }
        Defaults.removeSavedDevice(device)
        savedDevices = Defaults.savedDevices()
    }

    func refresh() {
        browser.refresh()
        reloadSavedDevices()
    }

    func reloadSavedDevices() {
        savedDevices = Defaults.savedDevices()
        delegate?.nearbyDevicesChanged()
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

extension BrowserRecord: DeviceSelectItem {
    var icon: UIImage {
        return R.image.lampOff()!
    }
    
    var details: String {
        return chipId
    }
}
