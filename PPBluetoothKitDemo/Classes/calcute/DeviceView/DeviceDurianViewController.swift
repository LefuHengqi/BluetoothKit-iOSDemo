//
//  DeviceAppleViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/10.
//

import UIKit
import PPBluetoothKit

class DeviceDurianViewController: BaseViewController {

    
    var XM_Durian : PPBluetoothPeripheralDurian?
    var XM_ScaleHistoryList : Array<PPBluetoothScaleBaseModel>? //同步历史数据
    var scaleCoconutViewController:ScaleCoconutViewController?

    
    var array = [DeviceMenuType.connectDevice, DeviceMenuType.startMeasure,  DeviceMenuType.changeUnit]
    
    let user : PPTorreSettingModel = {
        
        let uu = PPTorreSettingModel()
        
        uu.isAthleteMode = false
        uu.isPregnantMode = false
        
        uu.height = 180
        uu.age = 20
        uu.gender = PPDeviceGenderType.female
        uu.unit = .unitKG
        
        uu.memberID = "1234567890"
        
        uu.userID = "abcdefghijklmn"
        
        uu.userName = "Tom"
        
        uu.targetWeight = 60
        
        uu.idealWeight = 50
        
        return uu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
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

extension DeviceDurianViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            self.addConsoleLog(ss: "centralManagerDidUpdate")
            
            self.consoleView.text = self.conslogStr
            
            self.scaleManager.searchSurroundDevice()
            
        }
        
      
    }
    

    
    
    
}

extension DeviceDurianViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        guard let deviceModel = self.deviceModel else {return}

        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Durian = PPBluetoothPeripheralDurian(peripheral: peripheral, andDevice: device)
            self.XM_Durian?.serviceDelegate = self
            self.XM_Durian?.cmdDelegate = self
//            self.XM_Coconut?.scaleDataDelegate = self

        }
        


    }
    
}

extension DeviceDurianViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverDeviceInfoService")

        self.addBleCmd(ss: "discoverFFF0Service")

        self.XM_Durian?.discoverFFF0Service()
        
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceDurianViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        self.XM_Durian?.scaleDataDelegate = self

        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")
        self.XM_IsConnect = true

        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green

    }
    
}


extension DeviceDurianViewController: PPBluetoothCMDDataDelegate{
    
    func syncDeviceHistorySuccess() { //同步历史数据成功
        
//        guard let deviceModel = self.deviceModel else {return}

        
//        self.XM_Coconut?.deleteDeviceHistoryData()//删除历史数据
        
        if let models = self.XM_ScaleHistoryList{
            
            models.forEach({ model in
                
                self.addStatusCmd(ss: "histroty---weight:\(model.weight)")
                
            })
            
        }
    }
    func syncDeviceTimeSuccess() {
        self.addStatusCmd(ss: "syncDeviceTimeSuccess")

    }
    func deleteDeviceHistoryDataSuccess() {
        self.addStatusCmd(ss: "deleteDeviceHistoryDataSuccess")

    }
    func deviceWillDisconnect() {
        
    }
}

extension DeviceDurianViewController:PPBluetoothCalculateInScaleDataDelegate{
   
    
    func monitorLockData(_ model: PPBodyFatModel!, advModel: PPBluetoothAdvDeviceModel!) {
        self.weightLbl.text = String.init(format: "weight lock:%0.2f", Float(model.ppWeightKg))
        
        self.weightLbl.textColor = UIColor.green
        
        let mm = PPBluetoothScaleBaseModel.init()
        
        mm.weight = Int(model.ppWeightKg) * 100
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = mm
        self.scaleCoconutViewController?.complete = true
    }
    
 
    
    
    func monitorHistoryData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.XM_ScaleHistoryList?.append(model)
    }
}

extension DeviceDurianViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceDurianViewController"
    }



}



extension DeviceDurianViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = array[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        
        cell.titleLbl.text = title.rawValue
        
        if title == .changeUnit{
            
            cell.titleLbl.text = "\(title.rawValue)(\(self.unit == PPDeviceUnit.unitKG ? "lb" : "kg"))"
        }
        
        if title == .startMeasure{
            
            cell.titleLbl.textColor = UIColor.green
            
        } else {
            cell.titleLbl.textColor = UIColor.black
        }
//        else  if title == .distributionNetwork{
//            cell.titleLbl.textColor = UIColor.red
//
//        }else{
//            cell.titleLbl.textColor = UIColor.black
//
//        }
        
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
//
        if title == .startMeasure{


            self.scaleCoconutViewController = ScaleCoconutViewController.instantiate()
            self.scaleCoconutViewController?.deviceModel = self.deviceModel

//            self.scaleCoconutViewController?.XM_Coconut = self.XM_Coconut
//            self.XM_Coconut.

            self.navigationController?.pushViewController(self.scaleCoconutViewController!, animated: true)

            return

        }

       
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")
            user.unit = PPDeviceUnit.unitLB
            self.XM_Durian?.syncDeviceSetting(user)
                
        }

    }
}
