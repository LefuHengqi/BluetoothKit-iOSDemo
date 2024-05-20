//
//  DeviceHamburgerViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/1
//  


import Foundation
import PPBluetoothKit

class DeviceHamburgerViewController: BaseViewController {

    
    var XM_Hamburger : PPBluetoothPeripheralHamburger?

    
    var scaleCoconutViewController:ScaleCoconutViewController?

    var array = [DeviceMenuType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        self.unit = PPDeviceUnit.unitG;
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

        }

        if let XM_Device = self.deviceModel {

            self.XM_Hamburger = PPBluetoothPeripheralHamburger.init(device: XM_Device)
            self.XM_Hamburger?.updateStateDelegate = self
            self.XM_Hamburger?.scaleDataDelegate = self
        }
        
        self.connectStateLbl.text = "Recevied advertisementData"
    }

    deinit{

        self.XM_Hamburger?.scaleDataDelegate = nil;
        self.XM_Hamburger?.updateStateDelegate = nil;
        self.XM_Hamburger?.stopSearch()
    }

}



extension DeviceHamburgerViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        self.addConsoleLog(ss: "centralManagerDidUpdate")

        if (state == .poweredOn){
            self.XM_Hamburger?.receivedDeviceData()
        }

    }
}

extension DeviceHamburgerViewController: PPBluetoothFoodScaleDataDelegate{
    
    func monitorData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.unit = model.unit;
        
        let weight = model.weight.toFoodUnitStr(deviceAccuracyType: PPDeviceAccuracyType(rawValue: UInt((self.deviceModel?.deviceAccuracyType.rawValue ?? 0))) ?? .unknow, unit: model.unit, deviceName: self.deviceModel?.deviceName ?? "", isPlus: model.isPlus)
        
        if model.isEnd{
            
            self.weightLbl.text = "weight lock:\(model.weight) unit:\(model.unit.rawValue) \n display:\(weight.0) \(weight.1)"

        }else{
            self.weightLbl.text = "weight process:\(model.weight) unit:\(model.unit.rawValue) \n display:\(weight.0) \(weight.1)"
        }
    }
}



extension DeviceHamburgerViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = array[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.titleLbl.text = title.rawValue
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake((UIScreen.main.bounds.size.width - 40) / 3,40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = array[indexPath.row]

    }

}


extension DeviceHamburgerViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceHamburgerViewController"
    }
}
