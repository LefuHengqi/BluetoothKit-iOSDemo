//
//  DeviceDorreViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/29.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit



class DeviceDorreViewController: BaseViewController {

    var XM_Dorre: PPBluetoothPeripheralDorre?
    

    var array = [
                 menuType.deviceInfo,
                 .equipmentHistorical,
                 .memberManager,
                 .wificonfigstatus,
                 .distributionNetwork,
                 .startMeasure,
                 menuType.SyncTime,
                 .clearDeviceData,
                 .checkBindState,
                 .keepAlive,
        .getUserInfoIsEdit ,
        .setUserInfoIsNotEdit,
        .setUserInfoIsEdit,
    ]
    
    var syncInfoComplete = false
    
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
        
        uu.currentWeight = 62.9
        
        uu.pIndex = 1
        
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
                        self.XM_Dorre?.sendKeepAliveCode()
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
        
        self.XM_Dorre?.scaleDataDelegate = self

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
        
        weightStr = isLock ? Localization.string("weight_lock") + weightStr : Localization.string("weight_process") + weightStr
        
        let inputModel = PPCalculateInputModel()
        inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
        inputModel.isAthleteMode = self.user.isAthleteMode
        inputModel.isPregnantMode = self.user.isPregnantMode
        inputModel.height = self.user.height
        inputModel.age = self.user.age
        inputModel.gender = self.user.gender
        inputModel.bodyAgeMethod = PPBodyAgeMethod(rawValue: UInt(advModel.getBodyAgeTypeCode())) ?? .default
        
        // Measurement completed
        if scaleModel.isEnd {
            
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
        if let peripheral = self.XM_Dorre?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }

    }

}
 
extension DeviceDorreViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
            
            
            let vc = BorreScaleViewController.instantiate()
            vc.deviceModel = self.deviceModel
            vc.XM_Obj = self.XM_Dorre
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            return
            
        }
        
        if title == .checkBindState{
            
            self.addBleCmd(ss: "codeFetchBindingState")

            self.XM_Dorre?.codeFetchBindingState({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
        }
        
        if title == .deviceInfo{
            
            self.addBleCmd(ss: "discoverDeviceInfoService")

            self.XM_Dorre?.discoverDeviceInfoService({ [weak self] model in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "modelNumber:\(model.modelNumber),firmwareRevision:\(model.firmwareRevision),hardwareRevision:\(model.hardwareRevision)")

            })
        }
        
        if title == .SyncTime{
            
            self.addBleCmd(ss: "codeSyncTime")
            
            self.XM_Dorre?.codeSyncTime({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

                
            })

        }
        
        
        if title == .SyncUser{
            
        
            
            self.addBleCmd(ss: "dataSyncUserInfo")
            
            self.XM_Dorre?.dataSyncUserInfo(user, withHandler: { [weak self] (status, errorType) in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "status:\(status) errorType:\(errorType)")

            })

        }
        
        if title == .ImpedanceSwitch{
            
            self.addBleCmd(ss: "codeFetchImpedanceSwitch")

            self.XM_Dorre?.codeFetchImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
      
        if title == .openImpedance{
            
            self.addBleCmd(ss: "codeOpenImpedanceSwitch")

            self.XM_Dorre?.codeOpenImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeImpedance{
            
            self.addBleCmd(ss: "codeCloseImpedanceSwitch")

            self.XM_Dorre?.codeCloseImpedanceSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .HeartRateSwitch{
            
            self.addBleCmd(ss: "codeFetchHeartRateSwitch")

            self.XM_Dorre?.codeFetchHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .openHeartRate{
            
            self.addBleCmd(ss: "codeOpenHeartRateSwitch")

            self.XM_Dorre?.codeOpenHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        if title == .closeHeartRate{
            
            self.addBleCmd(ss: "codeCloseHeartRateSwitch")

            self.XM_Dorre?.codeCloseHeartRateSwitch({ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })
            
        }
        
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")

            self.unit = self.unit == PPDeviceUnit.unitKG ? PPDeviceUnit.unitLB  : PPDeviceUnit.unitKG
            self.XM_Dorre?.codeChange(self.unit , withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")
                
                self.collectionView.reloadData()

            })
        }
        
        if title == .clearDeviceData{
            self.addBleCmd(ss: "codeClearDeviceData")
            
            self.XM_Dorre?.codeClearDeviceData(0, withHandler:{ [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

            })

        }
        
        if title == .getUserInfoIsEdit{
            
            self.addBleCmd(ss: "getUserInfoIsEdit")
            
            self.XM_Dorre?.codeGetUserInfoIsEdithandler({ isEdit in
                self.addStatusCmd(ss: "\(isEdit)")

            })
            
           
            
        }
        
        if title == .setUserInfoIsNotEdit{
            
            self.addBleCmd(ss: "setUserInfoIsNotEdit")
            
            self.XM_Dorre?.codeSetUserInfoIsEdit(false, handler: { status in
                self.addStatusCmd(ss: "\(status)")

            })
            
            
        }
        
        if title == .setUserInfoIsEdit{
            
            self.addBleCmd(ss: "setUserInfoIsEdit")
            
            self.XM_Dorre?.codeSetUserInfoIsEdit(true, handler: { status in
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
                    
                    self.XM_Dorre?.codeSetScreenLuminance(num, handler: { [weak self] statu in
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
            self.XM_Dorre?.sendKeepAliveCode()

            
        }
        
        if title == .wificonfigstatus{
            self.addBleCmd(ss: "codeFetchWifiConfig")
            self.XM_Dorre?.codeFetchWifiConfig({ [weak self] status in
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
            vc.XM_Dorre = self.XM_Dorre
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if title == .selectUser{
            
            self.addBleCmd(ss: "dataSelectUser")
            self.XM_Dorre?.dataSelectUser(self.user, withHandler: { [weak self] statu in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(statu)")

            })
        }
        
        if title == .deleteUser{
            
            self.addBleCmd(ss: "dataDeleteUser")
            self.XM_Dorre?.dataDeleteUser(self.user, withHandler: { [weak self] statu in
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
            self.XM_Dorre?.codeFetchWifiConfig({ [weak self] state in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(state)")
                
                if state == 1 {
                    
                    self.addBleCmd(ss: "codeOtaUpdate")
                    self.XM_Dorre?.codeOtaUpdate(handler: { [weak self] statu in
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
//            self.XM_Dorre?.startLocalUpdate(handle: { [weak self] status in
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
            self.XM_Dorre?.dataSyncLog({ [weak self] (progress, path, isFail) in
                guard let `self` = self else {
                    return
                }

                self.syncLog(progress: progress, filePath: path, isFailed: isFail)
                
            })
            
        }
        
       
        
        if title == .fetchUserInfo{
            self.addBleCmd(ss: "fetchUserInfo")

            self.XM_Dorre?.dataFetchUserID({ userids in
                                
                self.addStatusCmd(ss: "\(userids.description)")

            })
            
        }
        
        if title == .equipmentHistorical {
            let vc = DeviceHistoryDataViewController()
            vc.deviceModel = self.XM_Dorre?.deviceAdv
            vc.userInfo = self.user
            
            // 获取指定用户(UserId)下所有成员历史数据
            // Retrieve historical data for all members under a specified user (UserId)
            vc.onFetchLeftHistory = { [weak self] in
                guard let `self` = self else { return }
                
                self.addBleCmd(ss: "dataFetchHistoryData-user")
                vc.view.makeToastActivity(.center)
                self.XM_Dorre?.dataFetchHistoryData(self.user, withHandler: { models in
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
                self.XM_Dorre?.dataFetchHistoryData(guest, withHandler: {models in
                    vc.view.hideToastActivity()
                    
                    if models.count < 1 {
                        vc.view.makeToast(Localization.string("Historical_empty"))
                    }
                    
                    vc.setHistory(models, type: .right)
                })
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if title == .memberManager {
            let vc = DorreMemberViewController()
            vc.XM_Dorre = self.XM_Dorre
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
}

extension DeviceDorreViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        self.addConsoleLog(ss: "centralManagerDidUpdate:\(state)")

        self.consoleView.text = self.conslogStr
        
        if state == .poweredOn {
            
            self.scaleManager.searchSurroundDevice()
        }
    }
    

    
    
    
}

extension DeviceDorreViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self;
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Dorre = PPBluetoothPeripheralDorre(peripheral: peripheral, andDevice: device)
            self.XM_Dorre?.serviceDelegate = self
            self.XM_Dorre?.scaleDataDelegate = self
            
        }
        


    }
    
}

extension DeviceDorreViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Dorre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = Localization.string("disconnect")
        
        self.connectStateLbl.textColor = UIColor.red
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
}

extension DeviceDorreViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        
        // Update MTU → Sync Time → Sync User Data → Select User → Start Measurement
        // 更新MTU->同步时间->同步用户信息->选择用户->开始测量
        
        self.addBleCmd(ss: "codeUpdateMTU")
        self.XM_Dorre?.codeUpdateMTU {[weak self] mtuStatus in
            guard let `self` = self else { return }
            self.addStatusCmd(ss: "\(mtuStatus == 0 ? "success" : "failed")")
            
            if mtuStatus != 0 {
                return
            }
            
            
            self.connectStateLbl.text = Localization.string("connected")
            self.connectStateLbl.textColor = UIColor.green
            self.XM_IsConnect = true

            
            self.addBleCmd(ss: "codeSyncTime")
            self.XM_Dorre?.codeSyncTime {[weak self] timeStatus in
                guard let `self` = self else { return }
                self.addStatusCmd(ss: "\(timeStatus == 0 ? "success" : "failed")")
                
                self.addBleCmd(ss: "dataSyncUserInfo")
                self.XM_Dorre?.dataSyncUserInfo(self.user) {[weak self] syncStatus, errorType in
                    guard let `self` = self else { return }
                    self.addStatusCmd(ss: "\(syncStatus == 0 ? "success" : "failed")")
                    
                    self.addBleCmd(ss: "dataSelectUser")
                    self.XM_Dorre?.dataSelectUser(self.user) {[weak self] selectStatus in
                        guard let `self` = self else { return }
                        self.addStatusCmd(ss: "\(selectStatus == 0 ? "success" : "failed")")
                        
                        self.syncInfoComplete = true
                        
                        self.addBleCmd(ss: "codeStartMeasure")
                        self.XM_Dorre?.codeStartMeasure {[weak self] startStatus in
                            guard let `self` = self else { return }
                            self.addStatusCmd(ss: "\(startStatus == 0 ? "success" : "failed")")
                            
                        }
                    }
                }
            }
        }

    }
    
}

extension DeviceDorreViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: false)
        
        self.weightLbl.textColor = UIColor.red
        
    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: true)
        
        self.weightLbl.textColor = UIColor.green
    }
    
    
    
}

extension DeviceDorreViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "DeviceDorreViewController"
    }
    
    
    
}

