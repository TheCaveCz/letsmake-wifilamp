//
//  ViewController.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 04/09/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceSelectVC: UIViewController {
    enum SectionType {
        case saved
        case nearby
    }
    private let sections: [SectionType] = [.saved, .nearby]
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet private var backgroundView: UIView!
    
    var viewModel: DeviceSelectVMProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetServiceBrowser
        tableView.backgroundView = backgroundView
        viewModel = DeviceSelectVM()
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
        switch (sections[section], viewModel.nearbyState) {
        case (.saved, _):
            return max(viewModel.savedDevices.count, 1)
        case (.nearby, .empty), (.nearby, .loading):
            return 1
        case (.nearby, .ready(let items)):
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (sections[indexPath.section], viewModel.nearbyState, viewModel.savedDevices.count) {
        case (.saved, _, 0):
            return tableView.dequeue(DeviceSelectEmptyCell.self, for: indexPath)!
        case (.saved, _, _):
            return tableView.dequeue(DeviceSelectCell.self, for: indexPath, data: viewModel.savedDevices[indexPath.row])!
        case (.nearby, .empty, _):
            return tableView.dequeue(DeviceSelectNearbyEmptyCell.self, for: indexPath)!
        case (.nearby, .loading, _):
            return tableView.dequeue(DeviceSelectNearbyLoadingCell.self, for: indexPath)!
        case (.nearby, .ready(let items), _):
            return tableView.dequeue(DeviceSelectCell.self, for: indexPath, data: items[indexPath.row])!
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section] == .saved
    }
    
}


extension DeviceSelectVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == .saved && editingStyle == .delete {
            viewModel.deleteSaved(index: indexPath.row)
        }
    }
    
}
