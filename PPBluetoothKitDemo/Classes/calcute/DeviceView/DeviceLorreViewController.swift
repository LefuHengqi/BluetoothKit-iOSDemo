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
    var modeStr = ""
    var needSyncFood = XM_FoodDetailModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        self.unit = PPDeviceUnit.unitG;
        
        self.connectDevice()

        // Do any additional setup after loading the view.
        
        self.setupFoodDetail()
    }
    
    func connectDevice(){
        
        self.scaleManager = PPBluetoothConnectManager()
        self.scaleManager.updateStateDelegate = self;
        self.scaleManager.surroundDeviceDelegate = self;
        
    }
    
    func setupFoodDetail() {
        
        let food = XM_FoodDetailModel()
        food.foodId = "apple_id_666"
        food.foodName = "Apple"
        food.servingWeightGrams = 100
        food.lfCalories = 120
        food.lfProtein = 50
        food.lfTotalFat = 51
        food.lfSaturatedFat = 52
        food.pCusTransFat = 53
        food.lfTotalCarbohydrate = 54
        food.lfDietaryFiber = 55
        food.lfSugars = 56
        food.lfCholesterol = 57
        food.lfSodium = 58
        food.calciumMg = 59
        food.vitaminAG = 60
        food.vitaminB1G = 61
        food.vitaminB2G = 62
        food.vitaminB6G = 63
        food.vitaminB12G = 64
        food.vitaminCG = 65
        food.vitaminDG = 66
        food.vitaminEG = 67
        food.niacinMg = 68
        food.phosphorusMg = 69
        food.potassiumMg = 70
        food.magnesiumMg = 71
        food.ironMg = 72
        food.zincMg = 73
        food.seleniumMg = 74
        food.copperMg = 75
        food.manganeseMg = 76
        food.imageIndex = 13 // 0-49
        
        self.needSyncFood = food
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

        
        var ss = ""
        if !foodRemoteId.isEmpty, foodRemoteId == self.needSyncFood.foodId {
            let XM_WeightG:Float = CommonTool.XM_FoodScaleToGValue(model.weight, deviceAccuracyType: advModel.deviceAccuracyType)
            let calValue = CommonTool.XM_CalculateValue(total: self.needSyncFood.servingWeightGrams ?? 0, nutrient: self.needSyncFood.lfCalories ?? 0, current: XM_WeightG, isPlus: model.isPlus)
            let fatValue = CommonTool.XM_CalculateValue(total: self.needSyncFood.servingWeightGrams ?? 0, nutrient: self.needSyncFood.lfTotalFat ?? 0, current: XM_WeightG, isPlus: model.isPlus)
            let proValue = CommonTool.XM_CalculateValue(total: self.needSyncFood.servingWeightGrams ?? 0, nutrient: self.needSyncFood.lfProtein ?? 0, current: XM_WeightG, isPlus: model.isPlus)
            ss = String.init(format: "Calories:%.f  TotalFat:%.1f  Protein:%.1f", CommonTool.roundWithDecimal(Double(calValue),scale:1), CommonTool.roundWithDecimal(Double(fatValue),scale:1), CommonTool.roundWithDecimal(Double(proValue),scale:1))
        }

        if model.isEnd{
            
            self.weightLbl.text = "weight lock: \(weight.0) \(weight.1) \nmode: \(self.modeStr)\nfoodNo: \(model.foodInfo.foodNo) \noodRemoteId: \(foodRemoteId)\n\(ss)"
        }else{
            self.weightLbl.text = "weight process: \(weight.0) \(weight.1) \nmode: \(self.modeStr)\nfoodNo: \(model.foodInfo.foodNo) \nfoodRemoteId: \(foodRemoteId)\n\(ss)"
        }
 
    }
    
    func monitorScaleState(_ scaleState: PPScaleState!) {
        print("nutritionalScaleMode:\(scaleState.nutritionalScaleMode.rawValue)")
        switch scaleState.nutritionalScaleMode {
        case .weight:
            self.modeStr = "Weighing mode"
        case .food:
            self.modeStr = "Nutritional scale mode"
        case .custom:
            self.modeStr = "Custom mode"
        default:
            self.modeStr = ""
        }
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
                
                //
                let XM_Food = self.needSyncFood.XM_TransformPPFoodInfo(foodNo: 1)
                
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
                // Delete all food.
                // 删除全部食物
                XM_Food.foodNo = 255
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSizeMake((UIScreen.main.bounds.size.width - 40) / 3.0, 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 10
    }
}
