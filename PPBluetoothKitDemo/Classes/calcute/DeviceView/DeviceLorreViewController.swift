//
//  DeviceEggViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/12.
//

import UIKit
import PPBluetoothKit

class DeviceLorreViewController: BaseViewController {

    var XM_Lorre : PPBluetoothPeripheralLorre?

    var array = [DeviceMenuType.connectDevice, DeviceMenuType.changeUnit,DeviceMenuType.toZero,DeviceMenuType.SyncTime,DeviceMenuType.syncFood,DeviceMenuType.fetchFoodIDList, DeviceMenuType.deleteFood]
    
    var foodIDList = [PPKorreFoodInfo]()


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
        if let peripheral = self.XM_Lorre?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
    }

}

extension DeviceLorreViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceLorreViewController"
    }

}


extension DeviceLorreViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        self.addConsoleLog(ss: "centralManagerDidUpdate")

        if (state == .poweredOn){
            self.scaleManager.searchSurroundDevice()
        }
        
      
    }
}



extension DeviceLorreViewController:PPBluetoothConnectDelegate{
    
    func centralManagerDidConnect() {
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        self.addBleCmd(ss: "discoverFFF0Service")
        self.XM_Lorre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.addBleCmd(ss: "Disconnect")
        
        self.scaleManager = PPBluetoothConnectManager()
        self.scaleManager.updateStateDelegate = self
        self.scaleManager.surroundDeviceDelegate = self
    }
}

extension DeviceLorreViewController:PPBluetoothSurroundDeviceDelegate{
    
    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {

        if (device.deviceMac == self.deviceModel.deviceMac){
            
            self.scaleManager.stopSearch()
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Lorre = PPBluetoothPeripheralLorre(peripheral: peripheral, andDevice: device)
            self.XM_Lorre?.serviceDelegate = self
            
        }
    }
}


extension DeviceLorreViewController: PPBluetoothServiceDelegate{
    
    
    func discoverFFF0ServiceSuccess() {
        
    
        self.XM_Lorre?.scaleDataDelegate = self
        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")

        self.addBleCmd(ss: "codeUpdateMTU")
        self.XM_Lorre?.codeUpdateMTU({[weak self] statu in
            
            guard let `self` = self else {return}
            
            self.fetchFoodIDList()
            
            self.XM_IsConnect = true

            self.connectStateLbl.text = "connected"
            self.connectStateLbl.textColor = UIColor.green
        })
 
    }

}


extension DeviceLorreViewController: PPBluetoothFoodScaleDataDelegate{
    
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



extension DeviceLorreViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            self.XM_Lorre?.toZero(handler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
        }

       
        
        if title == .changeUnit{
            
            self.addBleCmd(ss: "changeUnit")
            
            self.XM_Lorre?.codeChange(self.unit, withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
            self.collectionView.reloadData()
                
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "syncTime")
            self.XM_Lorre?.codeSyncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "status:\(status)")
            })
            
            self.collectionView.reloadData()
        }

        
        if title == .syncFood {
            DispatchQueue.global().async {
                let XM_Semaphore = DispatchSemaphore(value: 0)
                
                self.addBleCmd(ss:"showFoodSyncStatus")
                self.XM_Lorre?.showFoodSyncStatus(handler: {[weak self] status in
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
                XM_Food.foodName = "Apple"
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
                
                XM_Food.calciumMg = CGFloat(50) // Calcium (mg)
                XM_Food.vitaminAG = CGFloat(51) // Vitamin A (g)
                XM_Food.vitaminB1G = CGFloat(52) // Vitamin B1 (g)
                XM_Food.vitaminB2G = CGFloat(53) // Vitamin B2 (g)
                XM_Food.vitaminB6G = CGFloat(54)  // Vitamin B6 (g)
                XM_Food.vitaminB12G = CGFloat(55) // Vitamin B12 (g)
                XM_Food.vitaminCG = CGFloat(56) // Vitamin C (g)
                XM_Food.vitaminDG = CGFloat(57) // Vitamin D (g)
                XM_Food.vitaminEG = CGFloat(58) // Vitamin E (g)
                XM_Food.niacinMg = CGFloat(59) // Niacin (mg)
                XM_Food.phosphorusMg = CGFloat(60) // Phosphorus (mg)
                XM_Food.potassiumMg = CGFloat(61)  // Potassium (mg)
                XM_Food.magnesiumMg = CGFloat(62) // Magnesium (mg)
                XM_Food.ironMg = CGFloat(63)  // Iron (mg)
                XM_Food.zincMg = CGFloat(64)  // Zinc (mg)
                XM_Food.seleniumMg = CGFloat(65) // Selenium (mg)
                XM_Food.copperMg = CGFloat(66)  // Copper (mg)
                XM_Food.manganeseMg = CGFloat(67) // Manganese (mg)
                XM_Food.imageIndex = 13 // // 0-49
                
                self.addBleCmd(ss:"dataSyncFoodInfo")
                self.XM_Lorre?.dataSyncFoodInfo(XM_Food, withHandler: {[weak self] status, errorCode in
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
                self.XM_Lorre?.hideFoodSyncStatus(handler: {[weak self] status in
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
        
        
        if title == .fetchFoodIDList {
            
            self.fetchFoodIDList()
        }
        
        if title == .deleteFood {
            DispatchQueue.global().async {
                let XM_Semaphore = DispatchSemaphore(value: 0)
                
                self.addBleCmd(ss:"showFoodSyncStatus")
                self.XM_Lorre?.showFoodSyncStatus(handler: {[weak self] status in
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
                self.addBleCmd(ss: "dataDeleteFood")
                let XM_Food = PPKorreFoodInfo()
                XM_Food.foodNo = 1 // food number
                self.XM_Lorre?.dataDeleteFood(XM_Food, withHandler: {[weak self] status, errorCode in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addConsoleLog(ss: "status:\(status) errorCode:\(errorCode)")
                    XM_Semaphore.signal()
                })
                
                let XM_Result1 = XM_Semaphore.wait(timeout: DispatchTime.now() + 2)
                if XM_Result1 == .timedOut {
                    self.addConsoleLog(ss: "dataDeleteFood TimedOut ")
                }
                
                self.addBleCmd(ss:"hideFoodSyncStatus")
                self.XM_Lorre?.hideFoodSyncStatus(handler: {[weak self] status in
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

    }

    func fetchFoodIDList() {
        
        self.addBleCmd(ss: "dataFetchFoodIDList")
        self.XM_Lorre?.dataFetchFoodIDList({[weak self] foodList in
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
