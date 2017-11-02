//
//  AutomaticSetupVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class AutomaticSetupVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressDescriptionLabel: UILabel!
    
    
    var viewModel: AutomaticSetupVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.startDeviceSetup()
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
        case .error(let error):
            activityIndicator?.stopAnimating()
            progressDescriptionLabel?.text = "Error: \(error.localizedDescription)"
        }
    }
}
