//
//  QRScannerVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

final class QRScannerVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var connectWithCodeButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!

    var actionScannedDevice: ((QRScannerVC, Device) -> Void)?
    
    // Create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    private lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped))
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeTextField.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    @IBAction func scanQRCodeTap(_ sender: UIButton) {
        showQRCodeReader()
    }
    
    @IBAction func connectWithCodeTapped(_ sender: UIButton) {
        guard let text = codeTextField.text else { return }
        didScanQRCode(metadata: text)
    }

     @objc private func cancelTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func didScanQRCode(metadata: String) {
        // TODO: basic validation for now
        guard metadata.count == 6 else {
            showInvalidQRCodeError()
            return
        }
        
        let deviceId = metadata
        // TODO: parse type of device, not just wifilamps
        let device = WiFiLamp(chipId: deviceId)
        
        actionScannedDevice?(self, device)
    }
    
    private func showInvalidQRCodeError() {
        let alert = UIAlertController(title: "Invalid QR code", message: "This QR code does not correspond to any WiFi lamp.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension QRScannerVC: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: { [weak self] in
            self?.didScanQRCode(metadata: result.value)
        })
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {}
}

private extension QRScannerVC {
    func setupUI() {
        navigationItem.title = "Setup new lamp"
        navigationItem.leftBarButtonItem = closeButton

        connectWithCodeButton.layer.cornerRadius = 4
        connectWithCodeButton.backgroundColor = UIColor(red: 128/255, green: 204/255, blue: 40/255, alpha: 1)
        connectWithCodeButton.tintColor = UIColor.white
        connectWithCodeButton.isEnabled = false

        scanButton.layer.cornerRadius = 4
        scanButton.layer.borderWidth = 1
        scanButton.layer.borderColor = UIColor(red: 128/255, green: 204/255, blue: 40/255, alpha: 1).cgColor
        scanButton.tintColor = UIColor(red: 128/255, green: 204/255, blue: 40/255, alpha: 1)

        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    func showQRCodeReader() {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }

    @objc func textFieldChanged() {
        connectWithCodeButton.isEnabled = !(codeTextField.text?.isEmpty ?? true)
    }
}
