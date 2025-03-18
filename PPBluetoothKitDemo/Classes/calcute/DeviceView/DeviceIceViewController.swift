//
//  DeviceIceViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/1
//  


import Foundation
import PPBluetoothKit
import PPCalculateKit

class DeviceIceViewController: BaseViewController {

    var XM_Ice: PPBluetoothPeripheralIce?
    
    var scaleCoconutViewController:ScaleCoconutViewController?
    
    var array:[menuType] = [.deviceInfo,.startMeasure,.SyncTime,.wificonfigstatus,.distributionNetwork,.changeUnit,.openHeartRate, .openImpedance, .closeImpedance, .closeHeartRate,.keepAlive]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.XM_Ice?.scaleDataDelegate = self

    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBleManager()
        
        consoleView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        consoleView.layer.borderWidth = 1
        
        consoleView.layer.cornerRadius = 12
        
        consoleView.layer.masksToBounds = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

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
                                          deviceMac: self.deviceModel.deviceMac,
                                          weight: CGFloat(calculateWeightKg),
                                          heartRate: scaleModel.heartRate,
                                          deviceCalcuteType: advModel.deviceCalcuteType,
                                          z20KhzLeftArmEnCode: scaleModel.z20KhzLeftArmEnCode,
                                          z20KhzRightArmEnCode: scaleModel.z20KhzRightArmEnCode,
                                          z20KhzLeftLegEnCode: scaleModel.z20KhzLeftLegEnCode,
                                          z20KhzRightLegEnCode: scaleModel.z20KhzRightLegEnCode,
                                          z20KhzTrunkEnCode: scaleModel.z20KhzTrunkEnCode,
                                          z100KhzLeftArmEnCode: scaleModel.z100KhzLeftArmEnCode,
                                          z100KhzRightArmEnCode: scaleModel.z100KhzRightArmEnCode,
                                          z100KhzLeftLegEnCode: scaleModel.z100KhzLeftLegEnCode,
                                          z100KhzRightLegEnCode: scaleModel.z100KhzRightLegEnCode,
                                          z100KhzTrunkEnCode: scaleModel.z100KhzTrunkEnCode)
            
            let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
            
            //Get the range of each body indicator
            let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
            let weightParam = detailModel.ppBodyParam_Weight
            print("weight-currentValue:\(weightParam.currentValue) range:\(weightParam.standardArray)  standardTitle:\(bodyDataJson[weightParam.standardTitle] ?? "") standSuggestion:\(bodyDataJson[weightParam.standSuggestion] ?? "") standeValuation:\(bodyDataJson[weightParam.standeValuation] ?? "")")
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

    deinit {
        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Ice?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
    }

}
 
extension DeviceIceViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.array[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        
        cell.titleLbl.text = title.rawValue
        
        if title == .changeUnit{
            
            cell.titleLbl.text = "\(title.rawValue)(\(self.unit == PPDeviceUnit.unitKG ? "lb" : "kg"))"
        }
        
        if title == .startMeasure{
            
            cell.titleLbl.textColor = UIColor.green
            
        }else  if title == .distributionNetwork{
            cell.titleLbl.textColor = UIColor.red

        }else{
            cell.titleLbl.textColor = UIColor.black

        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake((UIScreen.main.bounds.size.width - 40) / 3,50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = self.array[indexPath.row]

        
        if !self.XM_IsConnect{
            
            self.addStatusCmd(ss: "device disconnect")

            return
        }
        
        if title == .startMeasure{

            self.scaleCoconutViewController = ScaleCoconutViewController.instantiate()
            self.scaleCoconutViewController?.deviceModel = self.deviceModel
            self.navigationController?.pushViewController(self.scaleCoconutViewController!, animated: true)
            
            return
        }
        
        if title == .deviceInfo{
            
            self.addBleCmd(ss: "discoverDeviceInfoService")

            self.XM_Ice?.discoverDeviceInfoService({ [weak self] model in
                
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "modelNumber:\(model.modelNumber),firmwareRevision:\(model.firmwareRevision),hardwareRevision:\(model.hardwareRevision)")

            })
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "codeSyncTime")
            
            self.XM_Ice?.syncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }

        if title == .openHeartRate{
            
            self.addBleCmd(ss: "openHeartRateSwitch")

            self.XM_Ice?.openHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }
        
        if title == .closeHeartRate{
            
            self.addBleCmd(ss: "closeHeartRateSwitch")

            self.XM_Ice?.closeHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }
        
        if title == .openImpedance{
            
            self.addBleCmd(ss: "openImpedanceSwitch")

            self.XM_Ice?.openImpedanceSwitch({ [weak self] status in
                
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }
        
        if title == .closeImpedance{
            
            self.addBleCmd(ss: "closeImpedanceSwitch")

            self.XM_Ice?.closeImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }
        
        if title == .FetchHistory{
            self.addBleCmd(ss: "dataFetchHistoryData")
            
            self.XM_Ice?.dataFetchHistoryData(handler: { [weak self] models, error in
                guard let `self` = self else {
                    return
                }
                
                models.forEach { bb in
                    
                    self.addStatusCmd(ss: "histroty---weight:\(bb.weight)")
                    
                }
            })
        }
        
        if title == .changeUnit{
            self.addBleCmd(ss: "change unit")

            self.unit = self.unit == PPDeviceUnit.unitKG ? PPDeviceUnit.unitLB  : PPDeviceUnit.unitKG
            self.XM_Ice?.change(self.unit, withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
                self.collectionView.reloadData()
            })
        }
        
        if title == .keepAlive{
            self.addBleCmd(ss: "sendKeepAliveCode")
            self.XM_Ice?.sendKeepAliveCode()

            
        }
        
        if title == .wificonfigstatus{
            self.addBleCmd(ss: "queryWifiConfig")
            self.XM_Ice?.queryWifiConfig(handler: { [weak self] wifiInfo in
                guard let `self` = self else {
                    return
                }
                
                if let model = wifiInfo {
                    self.addBleCmd(ss: "Wi-Fi ssid:\(model.ssid) ")
                } else {
                    self.addBleCmd(ss: "Unallocated network")
                }
            })
        }
        
        if title == .distributionNetwork {
            self.addBleCmd(ss: "hasWifiFunc")
            
            let funcType = self.deviceModel.deviceFuncType
            if !PPBluetoothManager.hasWifiFunc(funcType) {
                
                self.addStatusCmd(ss: "The device does not support Wi Fi")
                return
            }

            self.addBleCmd(ss: "dataFindSurroundDevice")
            self.addBleCmd(ss: "hold on")
            
            self.XM_Ice?.dataFindSurroundDevice({ [weak self] wifiList, status in
                guard let `self` = self else {
                    return
                }
                
                for info in wifiList {
                    self.addStatusCmd(ss: "wifi:\(info.ssid)")
                }
                
                let vc = WifiConfigViewController.instantiate()
                vc.wifiList = wifiList
                
                vc.configHandle = { [weak self] (ssid, password, dns) in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addStatusCmd(ss: "ssid:\(ssid ?? "") password:\(password ?? "") dns:\(dns ?? "")")
                    
                    let wifiModel = PPWifiInfoModel()
                    wifiModel.ssid = ssid ?? ""
                    wifiModel.password = password ?? ""
                    
                    self.addBleCmd(ss: "changeDNS")
                    self.XM_Ice?.changeDNS(dns ?? "", withReciveDataHandler: {[weak self] isSuccess in
                        guard let `self` = self else {
                            return
                        }
                        
                        self.addStatusCmd(ss: "changeDNS-\(isSuccess)")
                        
                        if  isSuccess {
                            
                            self.addBleCmd(ss: "dataConfigNetWork")
                            self.XM_Ice?.dataConfigNetWork(wifiModel, withHandler: {[weak self] success, sn in
                                guard let `self` = self else {
                                    return
                                }
                                
                                self.addStatusCmd(ss: "\(status) \(sn)")
                                
                            })
                            
                        }
                        
                    })

                    
                    

                }

                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        if title == .queryDeviceTime{
            self.addBleCmd(ss: "queryDeviceTime")
            self.XM_Ice?.queryDeviceTime({[weak self] timeStr in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(timeStr)")
            })
        }
    }
}

extension DeviceIceViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        
        self.addConsoleLog(ss: "centralManagerDidUpdate")
        
        self.consoleView.text = self.conslogStr
        
        self.scaleManager.searchSurroundDevice()
    }
    

    
    
    
}

extension DeviceIceViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self;
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Ice = PPBluetoothPeripheralIce(peripheral: peripheral, andDevice: device)
            self.XM_Ice?.serviceDelegate = self
            self.XM_Ice?.scaleDataDelegate = self
            
        }
        


    }
    
}

extension DeviceIceViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        self.addConsoleLog(ss: "centralManagerDidConnect")
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Ice?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceIceViewController: PPBluetoothServiceDelegate{

    func discoverFFF0ServiceSuccess() {

        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")
        
        self.XM_IsConnect = true
        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green
        
        self.XM_Ice?.scaleDataDelegate = self

    }
    
}

extension DeviceIceViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel:advModel, isLock: false)
        
        self.weightLbl.textColor = UIColor.red
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = false
        print("timeStr:\(model.dateStr) \(model.dateTimeInterval)")
    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel:advModel, isLock: true)
        
        self.weightLbl.textColor = UIColor.green
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = true
    }
    
    
    
}

extension DeviceIceViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "DeviceIceViewController"
    }
    
    
    
}
