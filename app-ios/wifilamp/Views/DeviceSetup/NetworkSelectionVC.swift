//
//  NetworkSelectionVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class NetworkSelectionVC: UIViewController {

    var actionNetworkSelected: ((NetworkSelectionVC, _ selectedNetwork: WiFiNetwork, _ passphase: String?) -> Void)?
    var actionCancelled: ((NetworkSelectionVC) -> Void)?
    
    var viewModel: NetworkSelectionVM!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)))
        
        tableView.tableFooterView = UIView()
    }
    
    private func networkSelected(_ network: WiFiNetwork) {
        // Prompt for password if needed
        if network.isPasswordProtected {
            
            let alert = UIAlertController(title: "Password required", message: "Enter password for \(network.name):", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { passwordField in
                passwordField.clearButtonMode = .whileEditing
                passwordField.isSecureTextEntry = true
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { _ in
                let passphase = alert.textFields?.first?.text
                self.actionNetworkSelected?(self, network, passphase)
            }))
            present(alert, animated: true, completion: nil)
            
        } else {
            actionNetworkSelected?(self, network, nil)
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        actionCancelled?(self)
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
        networkSelected(viewModel.networks[indexPath.row])
    }
}
