//
//  DeviceBananaViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/10.
//

import UIKit
import PPBluetoothKit

class DeviceBananaViewController: BaseViewController {
    var XM_Banana : PPBluetoothPeripheralBanana!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let banana = PPBluetoothPeripheralBanana.init(device: self.deviceModel)
        self.XM_Banana = banana
        self.XM_Banana.updateStateDelegate = self
        self.XM_Banana.scaleDataDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    deinit{
        
        // 恢复设备的默认行为
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.XM_Banana.scaleDataDelegate = nil;
        self.XM_Banana.updateStateDelegate = nil;
        self.XM_Banana.stopSearch()
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

extension DeviceBananaViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            
            self.addConsoleLog(ss: "centralManagerDidUpdate")
            
            self.addBleCmd(ss: "receivedDeviceData")

            
            self.XM_Banana.receivedDeviceData()
            self.connectStateLbl.text = "connected"
            self.connectStateLbl.textColor = UIColor.green

        }
        
      
    }
    
}


extension DeviceBananaViewController: PPBluetoothScaleDataDelegate{
    
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


extension DeviceBananaViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceBananaViewController"
    }



}

