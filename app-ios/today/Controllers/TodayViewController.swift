//
//  TodayViewController.swift
//  today
//
//  Created by Martin Púčik on 02/02/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {

    // MARK: - IBOutlets
    private lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(DeviceTableViewCell.self, forCellReuseIdentifier: DeviceTableViewCell.cellId)
        table.tableFooterView = UIView.init()
        table.delegate = self
        table.dataSource = self
        return table
    }()

    private lazy var emptyView: TodayEmptyView = {
        let view = TodayEmptyView.init(frame: CGRect.zero)
        view.effectsView.effect = UIVibrancyEffect.widgetPrimary()
        return view
    }()
    
    // MARK: - Private Props
    private lazy var savedDevices: [WiFiLamp] = {
        debugPrint("--- saved devices")
//        return Defaults.savedDevices()
        let dev1 = WiFiLamp.init(chipId: "chip1", name: "chip1", localNetworkUrl: nil)
        let dev2 = WiFiLamp.init(chipId: "chip2", name: "chip2", localNetworkUrl: nil)
        let dev3 = WiFiLamp.init(chipId: "chip3", name: "chip3", localNetworkUrl: nil)
        return [dev1, dev2, dev3]
    }()

    private let rowHeight: CGFloat = 70

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let devicesHidden = savedDevices.isEmpty
        if devicesHidden && emptyView.superview == nil {
            addEmptyView()
            self.preferredContentSize = CGSize.init(width: CGFloat.infinity, height: rowHeight)
        } else {
            self.preferredContentSize = CGSize.init(width: CGFloat.infinity, height: activeDisplayMode == .compact ? rowHeight:(rowHeight * CGFloat(savedDevices.count)))
            emptyView.removeFromSuperview()
        }

        tableView.isHidden = devicesHidden
        emptyView.isHidden = !devicesHidden
    }
}

// MARK: - NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}

// MARK: - UITableViewDelegate
extension TodayViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}


// MARK: - UITableViewDataSource
extension TodayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.cellId, for: indexPath)
        if let cell = cell as? DeviceTableViewCell, indexPath.row < savedDevices.count {
            let device = savedDevices[indexPath.row]

        }
        return cell
    }
}

private extension TodayViewController {
    func setupLayout() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        view.addSubview(tableView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
        ])
    }

    func addEmptyView() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            emptyView.bottomAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0),
            emptyView.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0),
            emptyView.trailingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0)
        ])
    }
}
