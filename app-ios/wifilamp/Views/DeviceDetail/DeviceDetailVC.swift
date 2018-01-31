//
//  ViewController.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

class DeviceDetailVC: UIViewController, LoadingIndicatorProtocol {

    @IBOutlet weak private var colorPicker: SwiftHSVColorPicker!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    var viewModel: DeviceDetailVM! {
        didSet {
             viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        
        // load initial state
        self.viewModel.getInitialState()
        // until initial state loads
        self.showLoadingIndicator()
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let switchButton = sender as? UISwitch else { return }
        self.viewModel.updateState(isOn: switchButton.isOn)
    }

    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let menu = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        if viewModel.deviceIsSaved() {
            menu.addAction(UIAlertAction.init(title: "Remove device", style: .default, handler: { [weak self] _ in
                self?.viewModel.removeDeviceFromSaved()
            }))
        } else {
            menu.addAction(UIAlertAction.init(title: "Save device", style: .default, handler: { [weak self] _ in
                self?.viewModel.saveDevice()
            }))
        }

        present(menu, animated: true, completion: nil)
    }
}

extension DeviceDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.deviceDetailColorCell, for: indexPath, data: viewModel.colors[indexPath.row])!
    }
}

extension DeviceDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = viewModel.colors[indexPath.row]
        colorPicker.color = color
        viewModel.updateColor(color: color)
    }
}

extension DeviceDetailVC: SwiftHSVColorPickerDelegate {
    func colorPicker(_ picker: SwiftHSVColorPicker, didChangeColor color: UIColor) {
        self.viewModel.updateColor(color: color)
    }
}

extension DeviceDetailVC: DeviceDetailVMDelegate {
    
    func didFinishLoadingInitialData(_ color: UIColor, _ isOn: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.colorPicker.color = color
            self.switchButton.isOn = isOn
        })
        
        self.hideLoadingIndicator()
    }
    
    func displayError(message: String) {
        
        self.hideLoadingIndicator()
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [weak self] _ in
            if message == "Could not connect to the device." {
                // Pop detail when device can't be connected
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
