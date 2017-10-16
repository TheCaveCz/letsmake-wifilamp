//
//  ViewController.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceDetailVC: UIViewController {
    @IBOutlet weak private var colorPicker: SwiftHSVColorPicker!//ChromaColorPicker!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    var viewModel: DeviceDetailVM! {
        didSet {
            //viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
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
        colorPicker.color = viewModel.colors[indexPath.row]
    }
}

extension DeviceDetailVC: SwiftHSVColorPickerDelegate {
    func colorPicker(_ picker: SwiftHSVColorPicker, didChangeColor color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        print("\(Int(r*255)) \(Int(g*255)) \(Int(b*255))")
    }
    
    
}
