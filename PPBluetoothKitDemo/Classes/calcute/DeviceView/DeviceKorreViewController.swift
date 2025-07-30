//
//  DeviceEggViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/12.
//

import UIKit
import PPBluetoothKit

class DeviceKorreViewController: BaseViewController {

    var XM_Korre : PPBluetoothPeripheralKorre?

    var array = [DeviceMenuType.connectDevice, DeviceMenuType.changeUnit,DeviceMenuType.toZero,DeviceMenuType.SyncTime,DeviceMenuType.syncUserInfo,DeviceMenuType.selectUser,DeviceMenuType.deleteUser,DeviceMenuType.syncFood,DeviceMenuType.fetchFoodIDList, DeviceMenuType.deleteFood,DeviceMenuType.FetchHistory]
    
    var foodIDList = [PPKorreFoodInfo]()
    let userID = "123456789"
    let memberID = "666666"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        self.unit = PPDeviceUnit.unitG;
        
        self.connectDevice()

        // Do any additional setup after loading the view.
    }
    
    func connectDevice(){
        
        self.scaleManager = PPBluetoothConnectManager()
        self.scaleManager.updateStateDelegate = self;
        self.scaleManager.surroundDeviceDelegate = self;
        
    }
    
    

    deinit{

        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Korre?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
    }

}

extension DeviceKorreViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceKorreViewController"
    }

}


extension DeviceKorreViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        self.addConsoleLog(ss: "centralManagerDidUpdate")

        if (state == .poweredOn){
            self.scaleManager.searchSurroundDevice()
        }
        
      
    }
}



extension DeviceKorreViewController:PPBluetoothConnectDelegate{
    
    func centralManagerDidConnect() {
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        self.addBleCmd(ss: "discoverFFF0Service")
        self.XM_Korre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.addBleCmd(ss: "Disconnect")
        
        self.scaleManager = PPBluetoothConnectManager()
        self.scaleManager.updateStateDelegate = self
        self.scaleManager.surroundDeviceDelegate = self
    }
}

extension DeviceKorreViewController:PPBluetoothSurroundDeviceDelegate{
    
    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {

        if (device.deviceMac == self.deviceModel.deviceMac){
            
            self.scaleManager.stopSearch()
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Korre = PPBluetoothPeripheralKorre(peripheral: peripheral, andDevice: device)
            self.XM_Korre?.serviceDelegate = self
            
        }
    }
}


extension DeviceKorreViewController: PPBluetoothServiceDelegate{
    
    
    func discoverFFF0ServiceSuccess() {
        
    
        self.XM_Korre?.scaleDataDelegate = self
        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")

        self.addBleCmd(ss: "codeUpdateMTU")
        self.XM_Korre?.codeUpdateMTU({[weak self] statu in
            
            guard let `self` = self else {return}
            
            self.fetchFoodIDList()
            
            self.XM_IsConnect = true

            self.connectStateLbl.text = "connected"
            self.connectStateLbl.textColor = UIColor.green
        })
 
    }

}


extension DeviceKorreViewController: PPBluetoothFoodScaleDataDelegate{
    
    func monitorData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.unit = model.unit;

        let weight = model.weight.toFoodUnitStr(deviceAccuracyType: PPDeviceAccuracyType(rawValue: UInt((self.deviceModel?.deviceAccuracyType.rawValue ?? 0))) ?? .unknow, unit: model.unit, deviceName: self.deviceModel?.deviceName ?? "", isPlus: model.isPlus)
        
        var foodRemoteId = ""
        if let foodInfo = self.foodIDList.first(where: { food in
            food.foodNo == model.foodInfo.foodNo
        }) {
            foodRemoteId = foodInfo.foodRemoteId
        }
        
        if model.isEnd{
            
            self.weightLbl.text = "weight lock: \(weight.0) \(weight.1) \n foodNo: \(model.foodInfo.foodNo) \n foodRemoteId: \(foodRemoteId)"

        }else{
            self.weightLbl.text = "weight process: \(weight.0) \(weight.1) \n foodNo: \(model.foodInfo.foodNo) \n foodRemoteId: \(foodRemoteId)"
        }
    }
    
    func monitorScaleState(_ scaleState: PPScaleState!) {
        print("nutritionalScaleMode:\(scaleState.nutritionalScaleMode.rawValue)")
    }
}



extension DeviceKorreViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

        
        if !self.XM_IsConnect{

            self.addStatusCmd(ss: "device disconnect")



            return
        }

        if title == .toZero{
         
            self.addBleCmd(ss: "toZero")
            self.XM_Korre?.toZero(handler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
        }

       
        
        if title == .changeUnit{
            
            self.addBleCmd(ss: "changeUnit")
            
            self.XM_Korre?.codeChange(self.unit, withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
            self.collectionView.reloadData()
                
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "syncTime")
            self.XM_Korre?.codeSyncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
            self.collectionView.reloadData()
        }

        if title == .syncUserInfo {
            
            self.addBleCmd(ss:"dataSyncUserInfo \n userID:\(self.userID) \n memberID:\(self.memberID)")
            
            let XM_KorreUser = PPKorreUserModel()
            XM_KorreUser.userAccount(self.userID, memberId: self.memberID)
            XM_KorreUser.targetIntake = 3000
            XM_KorreUser.currentIntake = 250
            XM_KorreUser.syncCurrentIntake = 1
            
            self.XM_Korre?.dataSyncUserInfo(XM_KorreUser, withHandler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
        }
        
        if title == .selectUser {
            
            self.addBleCmd(ss:"dataSelectUser \n userID:\(self.userID) \n memberID:\(self.memberID)")
            let XM_userModel = PPKorreUserModel()
            XM_userModel.userAccount(self.userID, memberId: self.memberID)
            self.XM_Korre?.dataSelectUser(XM_userModel, withHandler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
        }
        
        if title == .deleteUser {
            
            self.addBleCmd(ss:"dataDeleteUser \n userID:\(self.userID) \n memberID:\(self.memberID)")
            let XM_userModel = PPKorreUserModel()
            XM_userModel.userAccount(self.userID, memberId: self.memberID)
            self.XM_Korre?.dataDeleteUser(XM_userModel, withHandler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
        }
        
        if title == .syncFood {
            DispatchQueue.global().async {
                let XM_Semaphore = DispatchSemaphore(value: 0)
                
                self.addBleCmd(ss:"showFoodSyncStatus")
                self.XM_Korre?.showFoodSyncStatus(handler: {[weak self] status in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addConsoleLog(ss: "status:\(status)")
                    XM_Semaphore.signal()
                })
                
                let XM_Result = XM_Semaphore.wait(timeout: DispatchTime.now() + 2)
                if XM_Result == .timedOut {
                    self.addConsoleLog(ss: "showFoodSyncStatus TimedOut ")
                }
                
                
                let XM_Food = PPKorreFoodInfo()
                XM_Food.foodNo = 1
                XM_Food.foodRemoteId = "cus_egg_id55"
                XM_Food.foodWeight = CGFloat(100)
                XM_Food.foodName = "egg"
                XM_Food.calories = CGFloat(200) // Calories
                XM_Food.protein = CGFloat(115) // Protein
                XM_Food.totalFat = CGFloat(300) // Total Fat
                XM_Food.saturatedFat = CGFloat(68) // Saturated Fat
                XM_Food.transFat = CGFloat(57) // Trans Fat
                XM_Food.totalCarbohydrates = CGFloat(89)  // Total Carbohydrates
                XM_Food.dietaryFiber = CGFloat(30)  // Dietary Fiber
                XM_Food.sugars = CGFloat(35)  // Sugars
                XM_Food.cholesterol = CGFloat(40)  // Cholesterol
                XM_Food.sodium = CGFloat(45)  // Sodium
                
                self.addBleCmd(ss:"dataSyncFoodInfo")
                self.XM_Korre?.dataSyncFoodInfo(XM_Food, withHandler: {[weak self] status, errorCode in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addConsoleLog(ss: "status:\(status)")
                    XM_Semaphore.signal()
                })
                
                let XM_Result1 = XM_Semaphore.wait(timeout: DispatchTime.now() + 3)
                if XM_Result1 == .timedOut {
                    self.addConsoleLog(ss: "dataSyncFoodInfo TimedOut ")
                }
                
                self.addBleCmd(ss:"hideFoodSyncStatus")
                self.XM_Korre?.hideFoodSyncStatus(handler: {[weak self] status in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addConsoleLog(ss: "status:\(status)")
                    XM_Semaphore.signal()
                })
                
                let XM_Result2 = XM_Semaphore.wait(timeout: DispatchTime.now() + 2)
                if XM_Result2 == .timedOut {
                    self.addConsoleLog(ss: "hideFoodSyncStatus TimedOut ")
                }
                
            }
        }
        
        if title == .FetchHistory {
            
            self.addBleCmd(ss: "dataFetchFoodHistory")
            let XM_PPUser = PPKorreUserModel()
            XM_PPUser.userAccount(self.userID, memberId: self.memberID)
            self.XM_Korre?.dataFetchFoodHistory(XM_PPUser, withHandler: {[weak self] list, status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "history-count:\(list.count)")
                for item in list {
                    self.addConsoleLog(ss: "history:\(item.weight) foodNo:\(item.foodInfo.foodNo)")
                }
            })
            
        }
        
        if title == .fetchFoodIDList {
            
            self.fetchFoodIDList()
        }
        
        if title == .deleteFood {
            
            self.addBleCmd(ss: "dataDeleteFood")
            let XM_Food = PPKorreFoodInfo()
            XM_Food.foodNo = 1 // food number
            self.XM_Korre?.dataDeleteFood(XM_Food, withHandler: {[weak self] status, errorCode in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status) errorCode:\(errorCode)")
            })
        }

    }

    func fetchFoodIDList() {
        
        self.addBleCmd(ss: "dataFetchFoodIDList")
        self.XM_Korre?.dataFetchFoodIDList({[weak self] foodList in
            guard let `self` = self else {
                return
            }
            
            self.addConsoleLog(ss: "foodList-count:\(foodList.count)")
            for item in foodList {
                self.addConsoleLog(ss: "foodNo:\(item.foodNo) foodRemoteId:\(item.foodRemoteId ?? "")")
            }
            
            self.foodIDList = foodList
        })
    }
}
