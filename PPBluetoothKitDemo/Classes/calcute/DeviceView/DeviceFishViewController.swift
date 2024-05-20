//
//  DeviceEggViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/12.
//

import UIKit
import PPBluetoothKit

class DeviceFishViewController: BaseViewController {

    
    var XM_Fish : PPBluetoothPeripheralFish?

    
    var scaleCoconutViewController:ScaleCoconutViewController?

    var array = [DeviceMenuType.connectDevice, DeviceMenuType.changeUnit,DeviceMenuType.toZero,DeviceMenuType.SyncTime,DeviceMenuType.changeBuzzerGate]

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
    
    

    deinit{

        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Fish?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
    }

}

extension DeviceFishViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceFishViewController"
    }



}


extension DeviceFishViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        self.addConsoleLog(ss: "centralManagerDidUpdate")

        if (state == .poweredOn){
            self.scaleManager.searchSurroundDevice()
        }
        
      
    }
}



extension DeviceFishViewController:PPBluetoothConnectDelegate{
    
    func centralManagerDidConnect() {
        self.addConsoleLog(ss: "centralManagerDidConnect")

        self.addBleCmd(ss: "discoverDeviceInfoService")
        self.XM_Fish?.discoverDeviceInfoService({ [weak self] model in
            guard let `self` = self else {return}
            
            self.addBleCmd(ss: "discoverFFF0Service")
            self.XM_Fish?.discoverFFF0Service()
        })
    }
}

extension DeviceFishViewController:PPBluetoothSurroundDeviceDelegate{
    
    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {

        if (device.deviceMac == self.deviceModel.deviceMac){
            
            self.scaleManager.stopSearch()
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Fish = PPBluetoothPeripheralFish(peripheral: peripheral, andDevice: device)
            self.XM_Fish?.serviceDelegate = self
            
        }
    }
}


extension DeviceFishViewController: PPBluetoothServiceDelegate{
    
    
    func discoverFFF0ServiceSuccess() {
        
    
        self.XM_Fish?.scaleDataDelegate = self
        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")

        
        self.XM_IsConnect = true

        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green
    }
    
    
}


extension DeviceFishViewController: PPBluetoothFoodScaleDataDelegate{
    
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



extension DeviceFishViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            self.XM_Fish?.toZero()
        }

       
        
        if title == .changeUnit{
            self.addBleCmd(ss: "changeUnit")
            self.XM_Fish?.change(self.unit)
            
            self.collectionView.reloadData()
                
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "syncTime")
            self.XM_Fish?.syncTime(Date())
            
            self.collectionView.reloadData()
        }
        
        if title == .changeBuzzerGate{
            
            self.addBleCmd(ss: "changeBuzzerGate")
            self.XM_Fish?.changeBuzzerGate(false)
            
            self.collectionView.reloadData()
        }

    }

}
