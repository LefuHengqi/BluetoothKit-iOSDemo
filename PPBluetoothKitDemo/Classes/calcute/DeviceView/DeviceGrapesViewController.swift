//
//  DeviceEggViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/12.
//

import UIKit
import PPBluetoothKit

class DeviceGrapesViewController: BaseViewController {

    
    var XM_Grapes : PPBluetoothPeripheralGrapes?

    
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
        
        self.connectStateLbl.text = "Recevied advertisementData"
        self.connectStateLbl.textColor = UIColor.green
        guard let device = self.deviceModel else {return}

        let grapes = PPBluetoothPeripheralGrapes.init(device: device)
        self.XM_Grapes = grapes
        self.XM_Grapes?.updateStateDelegate = self
        self.XM_Grapes?.scaleDataDelegate = self

        // Do any additional setup after loading the view.
    }


}

extension DeviceGrapesViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceGrapesViewController"
    }

}

extension DeviceGrapesViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            self.addConsoleLog(ss: "centralManagerDidUpdate")

            self.XM_Grapes?.receivedDeviceData()
        }
    
    }
    
}


extension DeviceGrapesViewController: PPBluetoothFoodScaleDataDelegate{
    
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



extension DeviceGrapesViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

    }
}
