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

    // MARK: - Public UI
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet private var backgroundView: UIView!

    // MARK: - Public Props
    var viewModel: DeviceSelectVM! {
        didSet {
            viewModel.delegate = self
        }
    }

    var actionSelectDevice: ((DeviceSelectVC, DeviceSelectItem) -> Void)?
    var actionSetupNewDevice: ((DeviceSelectVC) -> Void)?

    // MARK: - Private Props
    private let sections: [SectionType] = [.saved, .nearby]

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl.init()
        control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        return control
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload saved devices
        allDevicesChanged()
    }
}

// MARK: - UITableViewDataSource
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
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectNearbyEmptyCell, for: indexPath)!
            cell.setIsLoading(viewModel.isLookingForNearby)
            return cell
        case (.nearby, _, _):
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSelectCell, for: indexPath, data: viewModel.nearbyDevices[indexPath.row])!
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (sections[indexPath.section] == .saved && !viewModel.savedDevices.isEmpty)
            || (sections[indexPath.section] == .nearby && !viewModel.nearbyDevices.isEmpty)
    }
}

// MARK: - UITableViewDelegate
extension DeviceSelectVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let device = device(for: indexPath) {
            actionSelectDevice?(self, device)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if sections[indexPath.section] == .saved {
            return [UITableViewRowAction.init(style: .destructive, title: "Delete", handler: { [weak self] (_, indexPath) in
                DispatchQueue.main.async {
                    self?.removeDevice(atIndex: indexPath.row)
                }
            })]
        } else {
            return [UITableViewRowAction.init(style: .normal, title: "Save", handler: { [weak self] (_, indexPath) in
                self?.viewModel.saveNearbyDevice(index: indexPath.row)
            })]
        }
    }
}

extension DeviceSelectVC: DeviceSelectVMDelegate {
    func nearbyDevicesChanged() {
        refreshControl.endRefreshing()
        tableView.reloadSections(IndexSet.init(integer: sections.index(of: .nearby)!), with: .automatic)
    }

    func allDevicesChanged() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

private extension DeviceSelectVC {
    enum SectionType {
        case saved
        case nearby
    }

    func device(for indexPath: IndexPath) -> DeviceSelectItem? {
        switch sections[indexPath.section] {
        case .saved:
            return viewModel.savedDevices[safe:indexPath.row]
        case .nearby:
            return viewModel.nearbyDevices[safe:indexPath.row]
        }
    }

    func removeDevice(atIndex index: Int) {
        guard let device = viewModel.savedDevices[safe:index] else { return }
        
        let controller = UIAlertController.init(title: "Warning", message: "Do you want to remove \(device.name) from saved devices?", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        controller.addAction(UIAlertAction.init(title: "Remove", style: UIAlertActionStyle.destructive, handler: { [weak self] _ in
            self?.viewModel.deleteSaved(index: index)
        }))
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Actions
    @IBAction private func addDeviceTap(_ sender: Any) {
        actionSetupNewDevice?(self)
    }

    @objc private func refresh() {
        viewModel.refresh()
    }
}
