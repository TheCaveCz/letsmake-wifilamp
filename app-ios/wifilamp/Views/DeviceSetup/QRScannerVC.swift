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

    var actionScannedDevice: ((QRScannerVC, Device) -> Void)?
    
    // Create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    private lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Setup new lamp"
    }
    
    @IBAction func scanQRCodeTap(_ sender: UIButton) {
        showQRCodeReader()
    }
    
    private func showQRCodeReader() {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    private func didScanQRCode(metadata: String) {
        // basic validation for now
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
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    }
}
