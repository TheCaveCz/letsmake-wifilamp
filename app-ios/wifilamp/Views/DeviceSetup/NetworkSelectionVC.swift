//
//  NetworkSelectionVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class NetworkSelectionVC: UIViewController {

    var actionNetworkSelected: ((NetworkSelectionVC, WiFiNetwork, String?) -> Void)?
    var actionCancelled: ((NetworkSelectionVC) -> Void)?
    
    var viewModel: NetworkSelectionVM!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
}

extension NetworkSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.networks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.wiFiNetworkCell, for: indexPath, data: viewModel.networks[indexPath.row])!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
