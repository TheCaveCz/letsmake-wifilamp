//
//  AutomaticSetupVM.swift
//  wifilamp
//
//  Created by Lukas Machalik on 02/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol AutomaticSetupVMDelegate: class {
    func stateChanged(_ state: AutomaticSetupVM.State)
}

final class AutomaticSetupVM {
    
    enum State {
        case notStarted
        case processingTask(desctiption: String, stepNumber: Int, totalNumberOfSteps: Int)
        case finished
        case error(Error)
    }
    
    private let device: Device
    weak var delegate: AutomaticSetupVMDelegate?
    
    private var state: State = .notStarted {
        didSet {
            delegate?.stateChanged(state)
        }
    }
    
    init(device: Device) {
        self.device = device
    }
    
    func startDeviceSetup() {
        state = .notStarted
        
        device.setup(
            success: { [weak self] in
                self?.state = .finished
            },
            failure: { [weak self] error in
                self?.state = .error(error)
            },
            progressUpdate: { [weak self] (taskDescription, stepNumber, totalNumberOfSteps) in
                self?.state = .processingTask(desctiption: taskDescription, stepNumber: stepNumber, totalNumberOfSteps: totalNumberOfSteps)
            }
        )
    }
}
