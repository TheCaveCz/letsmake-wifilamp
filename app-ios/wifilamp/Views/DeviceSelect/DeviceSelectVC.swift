//
//  ViewController.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 04/09/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Rswift


class DeviceSelectVC: UIViewController {
    enum SectionType {
        case saved
        case nearby
    }
    private let sections: [SectionType] = [.saved, .nearby]
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet private var backgroundView: UIView!
    
    var viewModel: DeviceSelectVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    var actionSelectDevice: ((DeviceSelectVC, DeviceSelectItem) -> Void)?
    var actionAddDevice: ((DeviceSelectVC) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = backgroundView
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func device(for indexPath: IndexPath) -> DeviceSelectItem? {
        switch sections[indexPath.section] {
        case .saved:
            return viewModel.savedDevices[safe:indexPath.row]
        case .nearby:
            return viewModel.nearbyDevices[safe:indexPath.row]
        }
    }

    @IBAction private func addDeviceTap(_ sender: Any) {
        actionAddDevice?(self)
    }
}


extension DeviceSelectVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .saved:
            return "Saved lamps"
        case .nearby:
            return "Nearby lamps"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .saved:
            return max(viewModel.savedDevices.count, 1)
        case .nearby:
            return max(viewModel.nearbyDevices.count, 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (sections[indexPath.section], viewModel.nearbyDevices.count, viewModel.savedDevices.count) {
        case (.saved, _, 0):
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectEmptyCell, for: indexPath)!
        case (.saved, _, _):
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectCell, for: indexPath, data: viewModel.savedDevices[indexPath.row])!
        case (.nearby, 0, _):
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectNearbyEmptyCell, for: indexPath)!
        case (.nearby, _, _):
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectCell, for: indexPath, data: viewModel.nearbyDevices[indexPath.row])!
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section] == .saved && !viewModel.savedDevices.isEmpty
    }
    
}


extension DeviceSelectVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let device = device(for: indexPath) {
            actionSelectDevice?(self, device)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == .saved && editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.deleteSaved(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
}


extension DeviceSelectVC: DeviceSelectVMDelegate {
    
    func nearbyDevicesChanged() {
        if let idx = sections.index(of: .nearby) {
            tableView.reloadSections([idx], with: .automatic)
        }
    }
    
}
