//
//  DeviceJambulViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/2
//  


import Foundation
import PPBluetoothKit

class DeviceJambulViewController: BaseViewController {
    var XM_Jambul : PPBluetoothPeripheralJambul?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let jambul = PPBluetoothPeripheralJambul.init(device: self.deviceModel)
        self.XM_Jambul = jambul
        self.XM_Jambul?.updateStateDelegate = self
        self.XM_Jambul?.scaleDataDelegate = self
        
        self.connectStateLbl.text = "Recevied advertisementData"
    }
    
    deinit{
        
        // 恢复设备的默认行为
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.XM_Jambul?.scaleDataDelegate = nil;
        self.XM_Jambul?.updateStateDelegate = nil;
        self.XM_Jambul?.stopSearch()
    }

}

extension DeviceJambulViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            
            self.addConsoleLog(ss: "centralManagerDidUpdate")
            self.addBleCmd(ss: "receivedDeviceData")
            
            self.XM_Jambul?.receivedDeviceData()
        }
    }
}


extension DeviceJambulViewController: PPBluetoothScaleDataDelegate {
    
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.weightLbl.text = String.init(format: "weight process:%0.2f", Float(model.weight) / 100.0)
        
        self.addConsoleLog(ss: "monitorProcessData")

        self.addStatusCmd(ss: model.description)

    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
     
        self.weightLbl.text = String.init(format: "weight lock:%0.2f", Float(model.weight) / 100.0)
        self.addConsoleLog(ss: "monitorLockData")

        self.addStatusCmd(ss: model.description)

    }
}


extension DeviceJambulViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceJambulViewController"
    }
}

