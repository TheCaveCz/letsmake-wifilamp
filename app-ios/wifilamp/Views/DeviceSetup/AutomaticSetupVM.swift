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
    
    func startDeviceSetup(delegate: DeviceSetupDelegate) {
        state = .notStarted
        
        device.setup(progressUpdate: { [weak self] (taskDescription, stepNumber, totalNumberOfSteps) in
            DispatchQueue.main.async {
                self?.state = .processingTask(desctiption: taskDescription, stepNumber: stepNumber, totalNumberOfSteps: totalNumberOfSteps)
            }
        }, delegate: delegate).then(on: DispatchQueue.main) { [weak self] _ in
            self?.state = .finished
        }.catch(on: DispatchQueue.main) { [weak self] error in
            self?.state = .error(error)
        }
    }
}
