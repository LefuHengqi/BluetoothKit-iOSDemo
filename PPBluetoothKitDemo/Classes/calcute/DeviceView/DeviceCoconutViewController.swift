//
//  DeviceCoconutViewController.swift
//  PPBluetoothKitDemo
//
//  Created by 杨青山 on 2023/8/9.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit



class DeviceCoconutViewController:BaseViewController{
  
    
    var scaleCoconutViewController:ScaleCoconutViewController?
    
    
    var XM_Coconut : PPBluetoothPeripheralCoconut?
    
    var XM_ScaleHistoryList : Array<PPBluetoothScaleBaseModel>? //同步历史数据

    var array = [DeviceMenuType.startMeasure, DeviceMenuType.SyncTime, DeviceMenuType.FetchHistory, DeviceMenuType.DeleteHistoryData, DeviceMenuType.changeUnit]
    
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
        
        self.setupBleManager()
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.XM_Coconut?.scaleDataDelegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
       
    }
    
    deinit {
        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Coconut?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
    }
    
    func setupBleManager(){
        
        self.scaleManager = PPBluetoothConnectManager()
        
        self.scaleManager.updateStateDelegate = self;
        
        self.scaleManager.surroundDeviceDelegate = self;
    }
    
    func displayScaleModel(_ scaleModel:PPBluetoothScaleBaseModel, advModel: PPBluetoothAdvDeviceModel, isLock:Bool) {
        
        let calculateWeightKg = Float(scaleModel.weight)/100
        
        var weightStr = calculateWeightKg.toCurrentUserString(accuracyType: Int(self.deviceModel.deviceAccuracyType.rawValue), unitType: Int(scaleModel.unit.rawValue),forWeight: true) + " \(Int(scaleModel.unit.rawValue).getUnitStr())"
        
        weightStr = isLock ? "weight lock:" + weightStr : "weight process:" + weightStr
        
        // Measurement completed
        if scaleModel.isEnd {
            
            // User information
            let user = PPBluetoothDeviceSettingModel()
            user.height = 160
            user.age = 20
            user.gender = .female
            user.isAthleteMode = false
            
            // Calculate body data (Eight electrodes)
            let fatModel = PPBodyFatModel(userModel: user,
                                          deviceCalcuteType: advModel.deviceCalcuteType,
                                          deviceMac: advModel.deviceMac,
                                          weight: CGFloat(calculateWeightKg),
                                          heartRate: scaleModel.heartRate,
                                          andImpedance: scaleModel.impedance,
                                          impedance100EnCode: scaleModel.impedance100EnCode
            )
            
            //Get the range of each body indicator
            let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
            let weightParam = detailModel.ppBodyParam_Weight
            print("weight-currentValue:\(weightParam.currentValue) weight-range:\(weightParam.standardArray)")
            //        print("data:\(detailModel.data)")
            
            
            let ss = CommonTool.getDesp(fatModel: fatModel, userModel: user)
            self.addStatusCmd(ss: ss)
        } else {
            
            if (scaleModel.isHeartRating) {
                
                weightStr = weightStr + "\nMeasuring heart rate..."
            } else if (scaleModel.isFatting) {
                
                weightStr = weightStr + "\nMeasuring body fat..."
            }
            
        }
        
        self.weightLbl.text = weightStr
    }

}


extension DeviceCoconutViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

        
        if !self.XM_IsConnect{

            self.addStatusCmd(ss: "device disconnect")



            return
        }
//
        if title == .startMeasure{


            self.scaleCoconutViewController = ScaleCoconutViewController.instantiate()
            self.scaleCoconutViewController?.deviceModel = self.deviceModel
//            self.XM_Coconut.

            self.navigationController?.pushViewController(self.scaleCoconutViewController!, animated: true)

            return

        }

        if title == .SyncTime{

            self.addBleCmd(ss: "codeSyncTime")

            self.XM_Coconut?.syncDeviceTime()

        }


        if title == .FetchHistory{
            self.addBleCmd(ss: "dataFetchHistoryData")
            self.XM_ScaleHistoryList = []
            self.XM_Coconut?.fetchDeviceHistoryData()

        }
        if title == .DeleteHistoryData{
            self.addBleCmd(ss: "deleteHistoryData")
            self.XM_Coconut?.deleteDeviceHistoryData()
        }
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")
            user.unit = PPDeviceUnit.unitLB

            self.XM_Coconut?.syncDeviceSetting(user)
                
        }

    }
}
extension DeviceCoconutViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        
        self.addConsoleLog(ss: "centralManagerDidUpdate")
        
        self.consoleView.text = self.conslogStr
        
        self.scaleManager.searchSurroundDevice()
    }
    

    
    
    
}

extension DeviceCoconutViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        guard let deviceModel = self.deviceModel else {return}

        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Coconut = PPBluetoothPeripheralCoconut(peripheral: peripheral, andDevice: device)
            self.XM_Coconut?.serviceDelegate = self
            self.XM_Coconut?.cmdDelegate = self
//            self.XM_Coconut?.scaleDataDelegate = self

        }
        


    }
    
}
extension DeviceCoconutViewController: PPBluetoothCMDDataDelegate{
    
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

extension DeviceCoconutViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Coconut?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceCoconutViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        self.XM_Coconut?.scaleDataDelegate = self

        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")
        self.XM_IsConnect = true

        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green
        
//        let funcType : PPDeviceFuncType = selectDevice!.0.deviceFuncType
//
//        if PPBluetoothManager.hasHistoryFunc(funcType){
//            
//            self.XM_Coconut?.syncDeviceTime()
//        }


    }
    
}

extension DeviceCoconutViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel: advModel, isLock: false)
        
        self.weightLbl.textColor = UIColor.red
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = false

    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel: advModel, isLock: true)
        
        self.weightLbl.textColor = UIColor.green
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = true

    }
    
    
    func monitorHistoryData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.XM_ScaleHistoryList?.append(model)
    }
}

extension DeviceCoconutViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    static var storyboardIdentifier: String {
        return "DeviceCoconutViewController"
    }
}

