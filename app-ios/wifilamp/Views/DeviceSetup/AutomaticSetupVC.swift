//
//  AutomaticSetupVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import PromiseKit
import AwaitKit

final class AutomaticSetupVC: UIViewController {

    var actionAskToSelectNetworkToConnect: ((AutomaticSetupVC, _ availableNetworks: [WiFiNetwork]) -> Promise<(selectedNetwork: WiFiNetwork, passphase: String?)>)?
    var actionSetupFinished: ((AutomaticSetupVC, _ success: Bool) -> Void)?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressDescriptionLabel: UILabel!
    
    var viewModel: AutomaticSetupVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startDeviceSetup(delegate: self)
    }
}

extension AutomaticSetupVC: AutomaticSetupVMDelegate {
    func stateChanged(_ state: AutomaticSetupVM.State) {
        switch state {
        case .notStarted:
            activityIndicator?.stopAnimating()
            progressDescriptionLabel?.text = "Initializing..."
        case .processingTask(let desctiption, let stepNumber, let totalNumberOfSteps):
            activityIndicator?.startAnimating()
            progressDescriptionLabel?.text = "\(stepNumber)/\(totalNumberOfSteps): \(desctiption)"
        case .finished:
            activityIndicator?.stopAnimating()
            progressDescriptionLabel?.text = "Success!"
            actionSetupFinished?(self, true)
        case .error(let error):
            activityIndicator?.stopAnimating()
            progressDescriptionLabel?.text = "Error: \(error.localizedDescription)"
        }
    }
}

extension AutomaticSetupVC: DeviceSetupDelegate {
    func askUserToSelectWiFiNetwork(from availableNetworks: [WiFiNetwork]) -> Promise<(selectedNetwork: WiFiNetwork, passphase: String?)> {
        return async {
            guard let actionAskToSelectNetworkToConnect = self.actionAskToSelectNetworkToConnect else {
                assert(false, "No action for network selection defined")
                throw DeviceSetupError.noNetworkSelected
            }
            
            return try await(actionAskToSelectNetworkToConnect(self, availableNetworks))
        }
    }
}
