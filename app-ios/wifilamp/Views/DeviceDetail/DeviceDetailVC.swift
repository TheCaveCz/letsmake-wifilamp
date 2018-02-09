//
//  ViewController.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        updateTitle()
        
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

        if viewModel.canSaveColor(colorPicker.color) {
            menu.addAction(UIAlertAction.init(title: "Save color", style: .default, handler: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.viewModel.saveColor(weakSelf.colorPicker.color)
                weakSelf.collectionView.reloadData()
            }))
        }

        menu.addAction(UIAlertAction.init(title: "Rename device", style: .default, handler: { [weak self] _ in
            self?.renameDevice()
        }))

        if viewModel.deviceIsSaved() {
            menu.addAction(UIAlertAction.init(title: "Remove device", style: .destructive, handler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.removeDevice()
                }
            }))
        } else {
            menu.addAction(UIAlertAction.init(title: "Save device", style: .default, handler: { [weak self] _ in
                self?.viewModel.saveDevice()
                SVProgressHUD.showSuccess(withStatus: "Saved")
                SVProgressHUD.dismiss(withDelay: 0.5)
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

    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        if viewModel.canRemoveColor(atIndex: indexPath.row) {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction.init(title: "Remove color", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.removeColor(atIndex: indexPath.row)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }))
            present(alertController, animated: true, completion: nil)
        }
        
        return true
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {}
}

extension DeviceDetailVC: SwiftHSVColorPickerDelegate {
    func colorPicker(_ picker: SwiftHSVColorPicker, didChangeColor color: UIColor) {
        viewModel.updateColor(color: color)

        if let index = viewModel.indexOfColor(color) {
            // Select saved color in collection
            collectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .top)
        } else {
            guard let selectedPaths = collectionView.indexPathsForSelectedItems else { return }
            for path in selectedPaths {
                collectionView.deselectItem(at: path, animated: false)
            }
        }
    }
}

extension DeviceDetailVC: DeviceDetailVMDelegate {
    
    func didFinishLoadingInitialData(_ color: UIColor, _ isOn: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.colorPicker.color = color
            self.switchButton.isOn = isOn
        })

        if let index = viewModel.indexOfColor(color) {
            // Select saved color in collection
            collectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .top)
        }

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

private extension DeviceDetailVC {
    func updateTitle() {
        navigationItem.title = viewModel.title
    }

    func removeDevice() {
        let controller = UIAlertController.init(title: "Warning", message: "Do you want to remove \(viewModel.title) from saved devices?", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction.init(title: "Remove", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.removeDeviceFromSaved()
            SVProgressHUD.showSuccess(withStatus: "Removed")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }))
        present(controller, animated: true, completion: nil)
    }

    func renameDevice() {
        let controller = UIAlertController.init(title: "Rename \(viewModel.title)", message: "Please, enter new device name", preferredStyle: .alert)
        controller.addTextField { [weak self] field in
            field.placeholder = "New device name"
            field.text = self?.viewModel.title
        }

        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction.init(title: "Rename", style: .default, handler: { [weak self] _ in
            guard let field = controller.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self?.viewModel.renameDevice(withNewName: text)
            self?.updateTitle()
            SVProgressHUD.showSuccess(withStatus: "Renamed")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }))
        
        present(controller, animated: true, completion: nil)
    }
}
