//
//  DeviceTorreViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/29.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

enum menuType:String{
    
    case connectDevice          = "menu_connectDevice"
        case checkBindState         = "menu_checkBindState"
        case deviceInfo             = "menu_deviceInfo"
        case startMeasure           = "menu_startMeasure"
        case stopMeasure           = "menu_stopMeasure"
        case SyncTime               = "menu_syncTime"
        case SyncUser               = "menu_syncUser"
        case ImpedanceSwitch        = "menu_impedanceSwitch"
        case HeartRateSwitch        = "menu_heartRateSwitch"

        case FetchHistory           = "menu_fetchHistory"
        case changeUnit             = "menu_changeUnit"
        case clearDeviceData        = "menu_clearDeviceData"
        case ScreenLuminance        = "menu_screenLuminance"
        case keepAlive              = "menu_keepAlive"
        case wificonfigstatus       = "menu_wifiConfigStatus"
        case distributionNetwork    = "menu_distributionNetwork"
        case selectUser             = "menu_selectUser"
        case deleteUser             = "menu_deleteUser"
        case getUserIDList          = "menu_getUserIDList"

        case openHeartRate          = "menu_openHeartRate"
        case closeHeartRate         = "menu_closeHeartRate"
        case openImpedance          = "menu_openImpedance"
        case closeImpedance         = "menu_closeImpedance"
        case otaUser                = "menu_otaUser"
        case otaLocal               = "menu_otaLocal"
        case dataSyncLog            = "menu_dataSyncLog"

        case impedanceTestMode      = "menu_impedanceTestMode"
        case openImpedanceTestMode  = "menu_openImpedanceTestMode"
        case closeImpedanceTestMode = "menu_closeImpedanceTestMode"

        case setTorreLanguage       = "menu_setTorreLanguage"
        case getTorreLanguage       = "menu_getTorreLanguage"

        case getRGBMode             = "menu_getRGBMode"
        case setRGBMode             = "menu_setRGBMode"
        case getUserMembers         = "menu_getUserMembers"

        case queryDeviceTime        = "menu_queryDeviceTime"

        case fetchUserInfo          = "menu_fetchUserInfo"
        case getUserInfoIsEdit      = "menu_getUserInfoIsEdit"
        case setUserInfoIsNotEdit   = "menu_setUserInfoIsNotEdit"
        case setUserInfoIsEdit      = "menu_setUserInfoIsEdit"
        case DFU                    = "menu_dfu"

        case showWifiIcon           = "menu_showWifiIcon"
        case hideWifiIcon           = "menu_hideWifiIcon"
        case getWifiIconStatus      = "menu_getWifiIconStatus"

        case setGravity             = "menu_setGravity"
        case getGravity             = "menu_getGravity"
        case specifyNicknameFontSize = "menu_specifyNicknameFontSize"
        case resetDevice            = "menu_resetDevice"
        case equipmentHistorical = "Equipment_Historical_Data"
        case deviceUser = "Device_User"
        case memberManager = "Member_Management"
}

class DeviceTorreViewController: BaseViewController {

    var XM_Torre: PPBluetoothPeripheralTorre?
    
    var syncInfoComplete = false
    var array = [.DFU, .equipmentHistorical, .deviceUser,menuType.startMeasure,menuType.SyncTime,.wificonfigstatus,.distributionNetwork,menuType.deviceInfo,.ImpedanceSwitch, .openImpedance, .closeImpedance,.changeUnit,.HeartRateSwitch, .openHeartRate, .closeHeartRate,.clearDeviceData,menuType.checkBindState,.ScreenLuminance,.keepAlive, .otaUser, .otaLocal, .dataSyncLog, .impedanceTestMode, .openImpedanceTestMode, .closeImpedanceTestMode, .setTorreLanguage, .getTorreLanguage, .showWifiIcon, .hideWifiIcon, .getWifiIconStatus, .setGravity, .getGravity, .specifyNicknameFontSize, .resetDevice]
    
    let user : PPTorreSettingModel = {
        
        let uu = PPTorreSettingModel()
        
        uu.isAthleteMode = false
        uu.isPregnantMode = false
        
        uu.height = 180
        uu.age = 28
        uu.gender = PPDeviceGenderType.female
        uu.unit = .unitKG
        
        uu.memberID = "1234567890"
        
        uu.userID = "abcdefghijklmn"
        
        uu.userName = "Tom"
        
        uu.targetWeight = 60
        
        uu.idealWeight = 50
        uu.birthYear = 1998
        uu.birthMonth = 1
        uu.birthDay = 20
        
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
                        self.XM_Torre?.sendKeepAliveCode()
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
        
        self.XM_Torre?.scaleDataDelegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
        self.connectStateLbl.text = Localization.string("disconnect")
        
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
        
        weightStr = isLock ? Localization.string("weight_lock") + weightStr : Localization.string("weight_process") + weightStr
        
        
        // Measurement completed
        if scaleModel.isEnd {
            
            
            let inputModel = PPCalculateInputModel()
            inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
            inputModel.isAthleteMode = self.user.isAthleteMode
            inputModel.isPregnantMode = self.user.isPregnantMode
            inputModel.height = self.user.height
            inputModel.age = self.user.age
            inputModel.gender = self.user.gender
            inputModel.unit = unit
            inputModel.bodyAgeMethod = PPBodyAgeMethod(rawValue: UInt(advModel.getBodyAgeTypeCode())) ?? .default
            
            var fatModel:PPBodyFatModel? = nil
            if (PPCalculateTools.is8Electrodes(with: advModel.deviceCalcuteType)) {
                // Calculate body data (Eight electrodes)
                
                
                inputModel.deviceCalcuteType = advModel.deviceCalcuteType
                inputModel.weight = CGFloat(calculateWeightKg)
                inputModel.z20KhzLeftArmEnCode = scaleModel.z20KhzLeftArmEnCode
                inputModel.z20KhzRightArmEnCode = scaleModel.z20KhzRightArmEnCode
                inputModel.z20KhzLeftLegEnCode = scaleModel.z20KhzLeftLegEnCode
                inputModel.z20KhzRightLegEnCode = scaleModel.z20KhzRightLegEnCode
                inputModel.z20KhzTrunkEnCode = scaleModel.z20KhzTrunkEnCode
                inputModel.z100KhzLeftArmEnCode = scaleModel.z100KhzLeftArmEnCode
                inputModel.z100KhzRightArmEnCode = scaleModel.z100KhzRightArmEnCode
                inputModel.z100KhzLeftLegEnCode = scaleModel.z100KhzLeftLegEnCode
                inputModel.z100KhzRightLegEnCode = scaleModel.z100KhzRightLegEnCode
                inputModel.z100KhzTrunkEnCode = scaleModel.z100KhzTrunkEnCode
                inputModel.deviceMac = advModel.deviceMac
                inputModel.heartRate = scaleModel.heartRate
                inputModel.footLen = scaleModel.footLen

                
                fatModel = PPBodyFatModel(inputModel: inputModel)
            } else {
                // Calculate body data (Four electrodes)


                inputModel.deviceCalcuteType = advModel.deviceCalcuteType
                inputModel.weight = CGFloat(calculateWeightKg)
                inputModel.impedance = scaleModel.impedance
                inputModel.impedance100EnCode = scaleModel.impedance100EnCode
                inputModel.deviceMac = advModel.deviceMac
                inputModel.heartRate = scaleModel.heartRate
                inputModel.footLen = scaleModel.footLen

                
                fatModel = PPBodyFatModel(inputModel: inputModel)
            }
            
            guard let fatModel = fatModel else {
                print("fatModel is nil")
                return
            }

            
            // Obtain information such as the judgment range and evaluation of each physical indicator.If the standardArray of the PPBodyDetailModel object is empty, then this metric has no judgment range.
            // 获取每个身体指标的判定范围和评价等信息，如果PPBodyDetailModel对象的standardArray为空，则该指标没有判定范围
            let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)

            let ss = CommonTool.getDesp(fatModel: fatModel, inputModel: inputModel)
            self.addStatusCmd(ss: ss)
            
            // Go to details page. 跳转详情页
            let bodyDetailVC = BodyDetailViewController()
            bodyDetailVC.errorType = fatModel.errorType
            bodyDetailVC.detailModel = detailModel
            self.navigationController?.pushViewController(bodyDetailVC, animated: true)
            
        } else {
            
            if (scaleModel.isHeartRating) {
                
                weightStr = weightStr + "\n\(Localization.string("Measuring_heart_rate"))"
            } else if (scaleModel.isFatting) {
                
                weightStr = weightStr + "\n\(Localization.string("Measuring_body_fat"))"
            }
            
        }
        
        self.weightLbl.text = weightStr
    }

    deinit{

        timer?.cancel()
        self.scaleManager.stopSearch()
        if let peripheral = self.XM_Torre?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }

    }

}
 
extension DeviceTorreViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.array[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        
        cell.titleLbl.text = Localization.string(title.rawValue)
        
        if title == .changeUnit{
            
            cell.titleLbl.text = "\(Localization.string(title.rawValue))(\(self.unit == PPDeviceUnit.unitKG ? "lb" : "kg"))"
        }
        
        if title == .startMeasure{
            
            cell.titleLbl.textColor = UIColor.green
            
        } else{
            cell.titleLbl.textColor = UIColor.black

        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = self.array[indexPath.row]

        
        if !self.XM_IsConnect{
            
            self.addStatusCmd(ss: "device disconnect")
            
            self.view.makeToast(Localization.string("disconnect"))
            
            return
        }
        
        if !self.syncInfoComplete {
            
            self.addConsoleLog(ss: "Synchronization incomplete")
            
            self.view.makeToast(Localization.string("synchronizationing"))
            
            return
        }
        
        if title == .startMeasure{
            
            
            let vc = ScaleViewController.instantiate()
            vc.deviceModel = self.deviceModel
            vc.XM_Torre = self.XM_Torre
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            return
            
        }
        
        if title == .checkBindState{
            
            self.addBleCmd(ss: "codeFetchBindingState")

            self.XM_Torre?.codeFetchBindingState({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
        }
        
        if title == .deviceInfo{
            
            self.addBleCmd(ss: "discoverDeviceInfoService")

            self.XM_Torre?.discoverDeviceInfoService({ [weak self] model in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "modelNumber:\(model.modelNumber),firmwareRevision:\(model.firmwareRevision),hardwareRevision:\(model.hardwareRevision)")

            })
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "codeSyncTime")
            
            self.XM_Torre?.codeSyncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

                
            })

        }
        
        
        if title == .SyncUser{
            
        
            
            self.addBleCmd(ss: "dataSyncUserInfo")
            self.XM_Torre?.dataSyncUserInfo(self.user, withHandler: { [weak self] (status, errorType) in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "status:\(status) errorType:\(errorType)")

            })

        }
        
        if title == .getUserIDList{
            
        
            
            self.addBleCmd(ss: "dataFetchUserID")
            
            self.XM_Torre?.dataFetchUserID({[weak self] userIDList in
                guard let `self` = self else {
                    return
                }
                self.addStatusCmd(ss: "count:\(userIDList.count)")
                for userID in userIDList {
                    self.addStatusCmd(ss: "userID:\(userID)")
                }
                
            })
        }
        
        if title == .ImpedanceSwitch{
            
            self.addBleCmd(ss: "codeFetchImpedanceSwitch")

            self.XM_Torre?.codeFetchImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .openImpedance{
            
            self.addBleCmd(ss: "codeOpenImpedanceSwitch")

            self.XM_Torre?.codeOpenImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeImpedance{
            
            self.addBleCmd(ss: "codeCloseImpedanceSwitch")

            self.XM_Torre?.codeCloseImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .HeartRateSwitch{
            
            self.addBleCmd(ss: "codeFetchHeartRateSwitch")

            self.XM_Torre?.codeFetchHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .DFU{
            

            let vc = DFUViewController.instantiate()
            
            vc.XM_Obj = self.XM_Torre
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if title == .openHeartRate{
            
            self.addBleCmd(ss: "codeOpenHeartRateSwitch")

            self.XM_Torre?.codeOpenHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeHeartRate{
            
            self.addBleCmd(ss: "codeCloseHeartRateSwitch")

            self.XM_Torre?.codeCloseHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")

            self.unit = self.unit == PPDeviceUnit.unitKG ? PPDeviceUnit.unitLB  : PPDeviceUnit.unitKG
            self.XM_Torre?.codeChange(self.unit , withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
                self.collectionView.reloadData()

            })
        }
        
        if title == .clearDeviceData{
            self.addBleCmd(ss: "codeClearDeviceData")
            
            self.XM_Torre?.codeClearDeviceData(0, withHandler:{ [weak self] status in
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
                    
                    self.XM_Torre?.codeSetScreenLuminance(num, handler: { [weak self] statu in
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
            self.XM_Torre?.sendKeepAliveCode()

            
        }
        
        if title == .wificonfigstatus{
            self.addBleCmd(ss: "codeFetchWifiConfig")
            self.XM_Torre?.codeFetchWifiConfig({ [weak self] status in
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
            
            let vc = WifiListViewController()
            vc.XM_Torre = self.XM_Torre
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if title == .selectUser{
            
            self.addBleCmd(ss: "dataSelectUser")
            self.XM_Torre?.dataSelectUser(self.user, withHandler: { [weak self] statu in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(statu)")

            })
        }
        
        if title == .deleteUser{
            
            self.addBleCmd(ss: "dataDeleteUser")
            self.XM_Torre?.dataDeleteUser(self.user, withHandler: { [weak self] statu in
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
            self.XM_Torre?.codeFetchWifiConfig({ [weak self] state in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(state)")
                
                if state == 1 {
                    
                    self.addBleCmd(ss: "codeOtaUpdate")
                    self.XM_Torre?.codeOtaUpdate(handler: { [weak self] statu in
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
            self.XM_Torre?.startLocalUpdate(handle: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
            })

        }
        
        if title == .dataSyncLog{
            
            self.addBleCmd(ss: "dataSyncLog")
            
            self.addStatusCmd(ss: "hold on...")
            self.XM_Torre?.dataSyncLog({ [weak self] (progress, path, isFail) in
                guard let `self` = self else {
                    return
                }

                self.syncLog(progress: progress, filePath: path, isFailed: isFail)
                
            })
            
        }
        
        if title == .impedanceTestMode {
            
            self.addBleCmd(ss: "fetchImpedanceTestMode")

            self.XM_Torre?.fetchImpedanceTestMode({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .openImpedanceTestMode {
            
            self.addBleCmd(ss: "openImpedanceTestMode")

            self.XM_Torre?.openImpedanceTestMode({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeImpedanceTestMode {
            
            self.addBleCmd(ss: "closeImpedanceTestMode")

            self.XM_Torre?.closeImpedanceTestMode({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .setTorreLanguage {
            
            self.addBleCmd(ss: menuType.setTorreLanguage.rawValue)

            self.XM_Torre?.setLanguage(.simplifiedChinese, completion: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
            })
            
        }
        
        if title == .getTorreLanguage {
            
            self.addBleCmd(ss: menuType.getTorreLanguage.rawValue)

            self.XM_Torre?.getLanguageWithCompletion({[weak self] (status, language) in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "status:\(status) language:\(language)")
                
            })
            
        }
        
        if title == .showWifiIcon {
            
            self.addBleCmd(ss: menuType.showWifiIcon.rawValue)

            self.XM_Torre?.showWifiIcon({[weak self] (status) in
                guard let `self` = self else {
                    return
                }
                
                let ret = status == 0 ? "success" : "failed"
                self.addStatusCmd(ss: "status:\(ret)")
                
            })
            
        }
        
        if title == .hideWifiIcon {
            
            self.addBleCmd(ss: menuType.hideWifiIcon.rawValue)

            self.XM_Torre?.hideWifiIcon({[weak self] (status) in
                guard let `self` = self else {
                    return
                }
                
                let ret = status == 0 ? "success" : "failed"
                self.addStatusCmd(ss: "status:\(ret)")
                
            })
            
        }
        
        if title == .getWifiIconStatus {
            
            self.addBleCmd(ss: menuType.getWifiIconStatus.rawValue)

            self.XM_Torre?.fetchWifiIconStatus({[weak self] (status) in
                guard let `self` = self else {
                    return
                }
                
                let str = status == 0 ? "open" : "close"
                
                self.addStatusCmd(ss: "status:\(str)")
                
            })
            
        }
        
        // 部分设备支持
        // Supported by some devices
        if title == .setGravity {
            self.addBleCmd(ss: menuType.setGravity.rawValue)

            self.XM_Torre?.setGravityAcceleration(1, hanlder: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "status:\(status)")
            })
        }
        // 部分设备支持
        // Supported by some devices
        if title == .getGravity {
            self.addBleCmd(ss: menuType.getGravity.rawValue)

            self.XM_Torre?.getGravityAcceleration(hanlder: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                self.addStatusCmd(ss: "result:\(result)")
            })
        }
        
        if title == .specifyNicknameFontSize{
            
            self.showNumberInputAlert {[weak self] (name, fontSize) in
                guard let `self` = self else { return }
                
                self.addBleCmd(ss: "dataSyncUserInfo-specify nickname font size")
                // Synchronize user information and specify nickname font size
                user.userName = name
                user.nameFontSize = fontSize
                self.XM_Torre?.dataSyncUserInfo(self.user, withHandler: { [weak self] (status, errorType) in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addStatusCmd(ss: "status:\(status) errorType:\(errorType)")

                })
                
            } cancelHandler: {
            }
        }
        
        if title == .resetDevice {
            self.addBleCmd(ss: menuType.resetDevice.rawValue)
            self.XM_Torre?.resetDevice { [weak self] status in
                guard let `self` = self else {
                    return
                }
                // 0-成功 1-失败
                // 0-Success 1-Failure
                self.addStatusCmd(ss: "status:\(status)")
            }
        }
        
        
        if title == .equipmentHistorical {
            let vc = DeviceHistoryDataViewController()
            vc.deviceModel = self.XM_Torre?.deviceAdv
            vc.userInfo = self.user
            
            // 获取指定用户(UserId)下所有成员历史数据
            // Retrieve historical data for all members under a specified user (UserId)
            vc.onFetchLeftHistory = { [weak self] in
                guard let `self` = self else { return }
                
                self.addBleCmd(ss: "dataFetchHistoryData-user")
                vc.view.makeToastActivity(.center)
                self.XM_Torre?.dataFetchHistoryData(self.user, withHandler: { models in
                    vc.view.hideToastActivity()
                    
                    if models.count < 1 {
                        vc.view.makeToast(Localization.string("Historical_empty"))
                    }
                    
                    vc.setHistory(models, type: .left)
                })
            }
            
            // 获取游客历史数据
            // Fetch visitor history data
            vc.onFetchRightHistory = { [weak self] in
                guard let `self` = self else { return }
                
                self.addBleCmd(ss: "dataFetchHistoryData-guest")

                vc.view.makeToastActivity(.center)
                let guest = PPTorreSettingModel()
                guest.touristAccount()
                self.XM_Torre?.dataFetchHistoryData(guest, withHandler: {models in
                    vc.view.hideToastActivity()
                    
                    if models.count < 1 {
                        vc.view.makeToast(Localization.string("Historical_empty"))
                    }
                    
                    vc.setHistory(models, type: .right)
                })
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if title == .deviceUser {
            let vc = DeviceUserViewController()
            vc.XM_Torre = self.XM_Torre
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
    
    
    func showNumberInputAlert(confirmHanlder:@escaping((_ name:String, _ value:Int)->Void), cancelHandler:@escaping(()->Void)) {
        let alertController = UIAlertController(
            title: "Synchronize user information",
            message: "Enter nickname and font size",
            preferredStyle: .alert
        )
        let name = self.user.userName
        alertController.addTextField {textField in
            textField.placeholder = "Enter username"
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
            textField.text = name
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter font size"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
            textField.becomeFirstResponder()
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let tf1 = alertController.textFields?.first, let tf2 = alertController.textFields?.last {
                let text1 = tf1.text ?? name
                let text2 = tf2.text ?? "0"
                
                if let number = Int(text2) {
                    
                    confirmHanlder(text1, number)
                } else {
                    print("Invalid input: \(text2)")
                    cancelHandler()
                }
            } else {
                print("empty")
                cancelHandler()
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelHandler()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DeviceTorreViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        self.addConsoleLog(ss: "centralManagerDidUpdate:\(state)")

        self.consoleView.text = self.conslogStr
        
        if state == .poweredOn {
            
            self.scaleManager.searchSurroundDevice()
        }
    }
    

    
    
    
}

extension DeviceTorreViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            self.scaleManager.connectDelegate = self;
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Torre = PPBluetoothPeripheralTorre(peripheral: peripheral, andDevice: device)
            self.XM_Torre?.serviceDelegate = self
            self.XM_Torre?.scaleDataDelegate = self
            
        }
        


    }
    
}

extension DeviceTorreViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        self.syncInfoComplete = false
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Torre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = Localization.string("disconnect")
        
        self.connectStateLbl.textColor = UIColor.red
        
        self.syncInfoComplete = false
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
}

extension DeviceTorreViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        // Update MTU → Sync Time → Sync User Data → Select User → Start Measurement
        // 更新MTU->同步时间->同步用户信息->选择用户->开始测量
        
        self.addBleCmd(ss: "codeUpdateMTU")
        self.XM_Torre?.codeUpdateMTU {[weak self] mtuStatus in
            guard let `self` = self else { return }
            self.addStatusCmd(ss: "\(mtuStatus == 0 ? "success" : "failed")")
            
            if mtuStatus != 0 {
                return
            }
            
            
            self.connectStateLbl.text = Localization.string("connected")
            self.connectStateLbl.textColor = UIColor.green
            self.XM_IsConnect = true

            
            self.addBleCmd(ss: "codeSyncTime")
            self.XM_Torre?.codeSyncTime {[weak self] timeStatus in
                guard let `self` = self else { return }
                self.addStatusCmd(ss: "\(timeStatus == 0 ? "success" : "failed")")
                
                self.addBleCmd(ss: "dataSyncUserInfo")
                self.XM_Torre?.dataSyncUserInfo(self.user) {[weak self] syncStatus, errorType in
                    guard let `self` = self else { return }
                    self.addStatusCmd(ss: "\(syncStatus == 0 ? "success" : "failed")")
                    
                    self.addBleCmd(ss: "dataSelectUser")
                    self.XM_Torre?.dataSelectUser(self.user) {[weak self] selectStatus in
                        guard let `self` = self else { return }
                        self.addStatusCmd(ss: "\(selectStatus == 0 ? "success" : "failed")")
                        
                        self.syncInfoComplete = true
                        
                        self.addBleCmd(ss: "codeStartMeasure")
                        self.XM_Torre?.codeStartMeasure {[weak self] startStatus in
                            guard let `self` = self else { return }
                            self.addStatusCmd(ss: "\(startStatus == 0 ? "success" : "failed")")
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    
}

extension DeviceTorreViewController:PPBluetoothScaleDataDelegate{
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

extension DeviceTorreViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "DeviceTorreViewController"
    }
    
    
    
}

