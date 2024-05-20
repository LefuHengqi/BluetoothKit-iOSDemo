//
//  DeviceEggViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/12.
//

import UIKit
import PPBluetoothKit

class DeviceEggViewController: BaseViewController {

    
    var XM_Egg : PPBluetoothPeripheralEgg?

    
    var scaleCoconutViewController:ScaleCoconutViewController?

    var array = [DeviceMenuType.connectDevice,  DeviceMenuType.changeUnit,DeviceMenuType.toZero]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        self.unit = PPDeviceUnit.unitG;
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

        }

        // Do any additional setup after loading the view.
    }
    
    func connectDevice(){
        
        self.scaleManager = PPBluetoothConnectManager()
        
        self.scaleManager.updateStateDelegate = self;
        
        self.scaleManager.surroundDeviceDelegate = self;
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeviceEggViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceEggViewController"
    }



}


extension DeviceEggViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            
            self.addConsoleLog(ss: "centralManagerDidUpdate")

            self.scaleManager.searchSurroundDevice()
        }
        
      
    }
}



extension DeviceEggViewController:PPBluetoothConnectDelegate{
    
    func centralManagerDidConnect() {
        
        //        self.XM_Coconut?.discoverDeviceInfoService()
        self.addBleCmd(ss: "centralManagerDidConnect")

        self.XM_Egg?.discoverFFF0Service()
        
        self.addBleCmd(ss: "discoverFFF0Service")
    }
    
}

extension DeviceEggViewController:PPBluetoothSurroundDeviceDelegate{
    
    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {

        guard let XM_DeviceModel = self.deviceModel else {return}

        
        if (device.deviceMac == self.deviceModel.deviceMac){
            
            self.scaleManager.stopSearch()
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Egg = PPBluetoothPeripheralEgg(peripheral: peripheral, andDevice: device)
            self.XM_Egg?.serviceDelegate = self
            
        }
    }
}


extension DeviceEggViewController: PPBluetoothServiceDelegate{
    
    
    func discoverFFF0ServiceSuccess() {
        
        self.addConsoleLog(ss: "discoverFFF0ServiceSuccess")

        self.XM_Egg?.scaleDataDelegate = self
        
        
        self.XM_IsConnect = true

        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green
    }
    
    
}


extension DeviceEggViewController: PPBluetoothFoodScaleDataDelegate{
    
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



extension DeviceEggViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

        
        if title == .connectDevice{

            if self.XM_IsConnect{

                return
            }

            self.connectDevice()

            return
        }
//
        if !self.XM_IsConnect{

            self.addStatusCmd(ss: "device disconnect")



            return
        }
        
        if title == .toZero{
         
            self.addBleCmd(ss: "toZero")
            self.XM_Egg?.toZero()
        }

       
        
        if title == .changeUnit{
            self.addBleCmd(ss: "changeUnit")
            self.XM_Egg?.change(self.unit)
                
        }

    }
}
