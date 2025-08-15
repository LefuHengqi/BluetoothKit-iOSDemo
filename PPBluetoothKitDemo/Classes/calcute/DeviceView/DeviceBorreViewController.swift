//
//  DeviceBorreViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/29.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit



class DeviceBorreViewController: BaseViewController {

    var XM_Borre: PPBluetoothPeripheralBorre?
    

    var array = [menuType.checkBindState,
                 .deviceInfo,
                 .selectUser,
                 .SyncTime,
                 .SyncUserList,
                 .deleteUser,
                 .ImpedanceSwitch,
                 .openImpedance,
                 .closeImpedance,
                 .changeUnit,
                 .clearDeviceData,
                 .keepAlive,
                 .getRGBMode,
                 .setRGBMode,
                 .FetchHistory,
    ]
    
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
        
        uu.pIndex = 05
        
        return uu
    }()
    
    var timer: DispatchSourceTimer?
    
    override var XM_IsConnect: Bool {
        
        didSet {
            
            if self.XM_IsConnect{
                
                timer =  DispatchSource.makeTimerSource(queue: DispatchQueue.global())
                timer?.schedule(deadline: .now() + 10, repeating: .seconds(10))
                timer?.setEventHandler {[weak self] in
                    
                    guard let `self` = self else {return}
                    
                    DispatchQueue.main.async {
                        self.addBleCmd(ss: "sendKeepAliveCode")
                        self.XM_Borre?.sendKeepAliveCode()
                    }
                }
                timer?.resume()
            }else{
                
                timer?.cancel()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.XM_Borre?.scaleDataDelegate = self

    }
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        consoleView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        consoleView.layer.borderWidth = 1
        
        consoleView.layer.cornerRadius = 12
        
        consoleView.layer.masksToBounds = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

        }
        
        self.connectDevice()
        
    }
    
    func connectDevice(){
        
        self.scaleManager = PPBluetoothConnectManager()
        
        self.scaleManager.updateStateDelegate = self;
        
        self.scaleManager.surroundDeviceDelegate = self;
    }
    
    
    func syncLog(progress:CGFloat, filePath:String, isFailed:Bool) {
        DispatchQueue.main.async {
            
            print("progress:\(progress) isFailed:\(isFailed)")

            if progress == 1 && filePath.count > 0{
                self.addConsoleLog(ss: "progress:\(progress) isFailed:\(isFailed)")
                self.addConsoleLog(ss: "filePath:\(filePath)")
                
                self.shareLog(path: filePath)
            }
        }
    }
    
    func shareLog(path:String) {
        
        let pathUrl = NSURL(fileURLWithPath: path)
        
        let shareLinks = [pathUrl]
        
        let activityViewController = UIActivityViewController(activityItems: shareLinks, applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(activityViewController, animated: true, completion: nil)
    
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
            
            var fatModel:PPBodyFatModel? = nil
            if (PPCalculateTools.is8Electrodes(with: advModel.deviceCalcuteType)) {
                // Calculate body data (Eight electrodes)
                fatModel = PPBodyFatModel(userModel: user,
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
            } else {
                // Calculate body data (Four electrodes)
                fatModel = PPBodyFatModel(userModel: user, deviceCalcuteType: advModel.deviceCalcuteType, deviceMac: self.deviceModel.deviceMac, weight: CGFloat(calculateWeightKg), heartRate: scaleModel.heartRate, andImpedance: scaleModel.impedance, impedance100EnCode: scaleModel.impedance100EnCode, footLen: scaleModel.footLen)
            }
            
            guard let fatModel = fatModel else {
                print("fatModel is nil")
                return
            }
            
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

    deinit{

        timer?.cancel()
        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Borre?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }

    }

}
 
extension DeviceBorreViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
            
            
            let vc = BorreScaleViewController.instantiate()
            vc.deviceModel = self.deviceModel
            vc.XM_Obj = self.XM_Borre
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            return
            
        }
        
        if title == .checkBindState{
            
            self.addBleCmd(ss: "codeFetchBindingState")

            self.XM_Borre?.codeFetchBindingState({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
        }
        
        if title == .deviceInfo{
            
            self.addBleCmd(ss: "discoverDeviceInfoService")

            self.XM_Borre?.discoverDeviceInfoService({ [weak self] model in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "modelNumber:\(model.modelNumber),firmwareRevision:\(model.firmwareRevision),hardwareRevision:\(model.hardwareRevision)")

            })
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "codeSyncTime")
            
            self.XM_Borre?.codeSyncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

                
            })

        }
        
        
        if title == .SyncUserList{
            
        
            
            self.addBleCmd(ss: "dataSyncUserList")
            
            self.XM_Borre?.dataSyncUserList([user], withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })

        }
        
        if title == .ImpedanceSwitch{
            
            self.addBleCmd(ss: "codeFetchImpedanceSwitch")

            self.XM_Borre?.codeFetchImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
      
        if title == .openImpedance{
            
            self.addBleCmd(ss: "codeOpenImpedanceSwitch")

            self.XM_Borre?.codeOpenImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeImpedance{
            
            self.addBleCmd(ss: "codeCloseImpedanceSwitch")

            self.XM_Borre?.codeCloseImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .HeartRateSwitch{
            
            self.addBleCmd(ss: "codeFetchHeartRateSwitch")

            self.XM_Borre?.codeFetchHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .openHeartRate{
            
            self.addBleCmd(ss: "codeOpenHeartRateSwitch")

            self.XM_Borre?.codeOpenHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeHeartRate{
            
            self.addBleCmd(ss: "codeCloseHeartRateSwitch")

            self.XM_Borre?.codeCloseHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .FetchHistory{
            self.addBleCmd(ss: "dataFetchHistoryData")
            
            self.XM_Borre?.dataFetchHistoryData(user, withHandler: { [weak self] models in
                guard let `self` = self else {
                    return
                }
                
                
                models.forEach { bb in
                    
                    self.addStatusCmd(ss: "histroty---weight:\(bb.weight)")
                    
                }
                
            })

        }
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")

            self.unit = self.unit == PPDeviceUnit.unitKG ? PPDeviceUnit.unitLB  : PPDeviceUnit.unitKG
            self.XM_Borre?.codeChange(self.unit , withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
                self.collectionView.reloadData()

            })
        }
        
        if title == .clearDeviceData{
            self.addBleCmd(ss: "codeClearDeviceData")
            
            self.XM_Borre?.codeClearDeviceData(0, withHandler:{ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })

        }
        
    
        
        if title == .ScreenLuminance {

            let alertController = UIAlertController(title: "Screen Luminance", message: "", preferredStyle: .alert)

            alertController.addTextField { (textField) in
                textField.placeholder = "input value"
                textField.keyboardType = .numberPad
            }

            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "ok", style: .default) { [weak self] (action) in
                guard let `self` = self else {
                    return
                }
                
                if let textField1 = alertController.textFields?[0] {
                    var num =  Int(textField1.text ?? "0") ?? 0
                    
                    if num < 0 || num > 100 {
                        num = 50
                    }
                    
                    self.addBleCmd(ss: "codeSetScreenLuminance")
                    
                    self.XM_Borre?.codeSetScreenLuminance(num, handler: { [weak self] statu in
                        guard let `self` = self else {
                            return
                        }
                        
                        self.addStatusCmd(ss: "\(statu)")
                        
                    });
                }
                
            }

            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)

        }

        
        if title == .keepAlive{
            self.addBleCmd(ss: "sendKeepAliveCode")
            self.XM_Borre?.sendKeepAliveCode()

            
        }
        
        if title == .wificonfigstatus{
            self.addBleCmd(ss: "codeFetchWifiConfig")
            self.XM_Borre?.codeFetchWifiConfig({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
            })
        }
        
        if title == .distributionNetwork{
            self.addBleCmd(ss: "hasWifiFunc")
            
            let funcType = self.deviceModel.deviceFuncType
            if !PPBluetoothManager.hasWifiFunc(funcType) {
                
                self.addStatusCmd(ss: "The device does not support Wi Fi")
                return
            }

            self.addBleCmd(ss: "dataFindSurroundDevice")
            self.addBleCmd(ss: "hold on")
            
            self.XM_Borre?.dataFindSurroundDevice({ [weak self] wifiList in
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
                    
                    self.addStatusCmd(ss: "ssid:\(ssid) password:\(password) dns:\(dns)")
                    
                    let wifiModel = PPWifiInfoModel()
                    wifiModel.ssid = ssid ?? ""
                    wifiModel.password = password ?? ""

                    let domain = dns ?? ""
                    
                    self.addBleCmd(ss: "dataConfigNetWork")
                    self.XM_Borre?.dataConfigNetWork(wifiModel, domain: domain, withHandler: { [weak self] status, error in
                        guard let `self` = self else {
                            return
                        }
                        
                        self.addStatusCmd(ss: "\(status)")
                        
                    })

                }

                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        if title == .selectUser{
            
            self.addBleCmd(ss: "dataSelectUser")
            self.XM_Borre?.dataSelectUser(self.user, withHandler: { [weak self] statu in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(statu)")

            })
        }
        
        if title == .deleteUser{
            
            self.addBleCmd(ss: "dataDeleteUser")
            self.XM_Borre?.dataDeleteUser(self.user, withHandler: { [weak self] statu in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(statu)")

            })
        }
        
        if title == .otaUser{
            
            self.addBleCmd(ss: "hasWifiFunc")
            let funcType = self.deviceModel.deviceFuncType
            if !PPBluetoothManager.hasWifiFunc(funcType) {
                
                self.addStatusCmd(ss: "The device does not support Wi Fi")
                return
            }
            
            self.addBleCmd(ss: "codeFetchWifiConfig")
            self.XM_Borre?.codeFetchWifiConfig({ [weak self] state in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(state)")
                
                if state == 1 {
                    
                    self.addBleCmd(ss: "codeOtaUpdate")
                    self.XM_Borre?.codeOtaUpdate(handler: { [weak self] statu in
                        guard let `self` = self else {
                            return
                        }
                        
                        self.addStatusCmd(ss: "\(statu)")
                    })
                } else {
                    self.addStatusCmd(ss: "WiFi configuration is required for OTA upgrade")
                }
            })
        }
        
        if title == .otaLocal{
            
            self.addBleCmd(ss: "hasWifiFunc")
            let funcType = self.deviceModel.deviceFuncType
            if !PPBluetoothManager.hasWifiFunc(funcType) {
                
                self.addStatusCmd(ss: "The device does not support Wi Fi")
                return
            }
            
            self.addStatusCmd(ss: "Local upgrade: There must be a Wi Fi with the name Test and password 12345678 on the local device, and the device will automatically connect to that Wi Fi (ssid: Test, password: 12345678)")
            
            self.addBleCmd(ss: "startLocalUpdate")
//            self.XM_Borre?.startLocalUpdate(handle: { [weak self] status in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "\(status)")
//                
//            })

        }
        
        if title == .dataSyncLog{
            
            self.addBleCmd(ss: "dataSyncLog")
            
            self.addStatusCmd(ss: "hold on...")
            self.XM_Borre?.dataSyncLog({ [weak self] (progress, path, isFail) in
                guard let `self` = self else {
                    return
                }

                self.syncLog(progress: progress, filePath: path, isFailed: isFail)
                
            })
            
        }
        
        if title == .setRGBMode{
            self.addBleCmd(ss: "setRGBMode")

            self.XM_Borre?.setRGBMode(true, lightMode: .always, normalColor: "#FF00FF", gainColor: "#FF00FF", lossColor: "#FF00FF", handler: { statu in
                
                self.addStatusCmd(ss: "\(statu)")

            })
        }
        

        
        
        if title == .getRGBMode{
            self.addBleCmd(ss: "getRGBMode")

            self.XM_Borre?.getRGBModeHandler({ enable,mode, color1, color2, color3 in
                
                self.addStatusCmd(ss: "enable:\(enable) mode:\(mode.rawValue) color1:\(color1.description) color2:\(color2.description) color3:\(color3.description)")

            })
        }
        
//        if title == .impedanceTestMode {
//            
//            self.addBleCmd(ss: "fetchImpedanceTestMode")

//            self.XM_Borre?.fetchImpedanceTestMode({ [weak self] status in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "\(status)")
//
//            })
            
//        }
//        
//        if title == .openImpedanceTestMode {
//            
//            self.addBleCmd(ss: "openImpedanceTestMode")

//            self.XM_Borre?.openImpedanceTestMode({ [weak self] status in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "\(status)")
//
//            })
            
//        }
        
//        if title == .closeImpedanceTestMode {
//            
//            self.addBleCmd(ss: "closeImpedanceTestMode")

//            self.XM_Borre?.closeImpedanceTestMode({ [weak self] status in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "\(status)")
//
//            })
            
//        }
        
//        if title == .setTorreLanguage {
//            
//            self.addBleCmd(ss: menuType.setTorreLanguage.rawValue)

//            self.XM_Borre?.setLanguage(.simplifiedChinese, completion: {[weak self] status in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "\(status)")
//                
//            })
            
//        }
        
//        if title == .getTorreLanguage {
//            
//            self.addBleCmd(ss: menuType.getTorreLanguage.rawValue)
//
//            self.XM_Borre?.getLanguageWithCompletion({[weak self] (status, language) in
//                guard let `self` = self else {
//                    return
//                }
//                
//                self.addStatusCmd(ss: "status:\(status) language:\(language)")
//                
//            })
//            
//        }
    }
    
}

extension DeviceBorreViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        self.addConsoleLog(ss: "centralManagerDidUpdate:\(state)")

        self.consoleView.text = self.conslogStr
        
        if state == .poweredOn {
            
            self.scaleManager.searchSurroundDevice()
        }
    }
    

    
    
    
}

extension DeviceBorreViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self;
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Borre = PPBluetoothPeripheralBorre(peripheral: peripheral, andDevice: device)
            self.XM_Borre?.serviceDelegate = self
            self.XM_Borre?.scaleDataDelegate = self
            
        }
        


    }
    
}

extension DeviceBorreViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Borre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceBorreViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        
        self.addBleCmd(ss: "codeUpdateMTU")

        
        self.XM_Borre?.codeUpdateMTU({[weak self] statu in
            
            
            guard let `self` = self else {return}
            
            self.addStatusCmd(ss: "\(statu)")

            
            self.connectStateLbl.text = "connected"
            
            self.connectStateLbl.textColor = UIColor.green
            
            self.XM_IsConnect = true

        })

    }
    
}

extension DeviceBorreViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: false)
        
        self.weightLbl.textColor = UIColor.red
        
    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: true)
        
        self.weightLbl.textColor = UIColor.green
    }
    
    func monitorScaleState(_ scaleState: PPScaleState!) {
        
        print("monitorScaleState --- captureZeroType:\(scaleState.captureZeroType) heartRateType:\(scaleState.heartRateType) impedanceType:\(scaleState.impedanceType) measureModeType:\(scaleState.measureModeType) measureResultType:\(scaleState.measureResultType) powerType:\(scaleState.powerType) weightType:\(scaleState.weightType)")
    }
    
}

extension DeviceBorreViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "DeviceBorreViewController"
    }
    
    
    
}

