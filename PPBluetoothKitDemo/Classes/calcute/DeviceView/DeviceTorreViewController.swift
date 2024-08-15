//
//  DeviceTorreViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/29.
//

import UIKit
import PPBluetoothKit


enum menuType:String{
    
    case connectDevice = "connect Device"
    case checkBindState = "check bindState"
    case deviceInfo = "device info"
    case startMeasure = "start measure"
    case SyncTime = "Sync time"
    case SyncUserList = "Sync user list"
    case ImpedanceSwitch = "Impedance Switch"
    case HeartRateSwitch = "HeartRate Switch"

    case FetchHistory = "Fetch History"
    case changeUnit = "Change unit"
    case clearDeviceData = "Clear DeviceData"
    case ScreenLuminance = "ScreenLuminance"
    case keepAlive = "keep connect alive"
    case wificonfigstatus = "wifi config"
    case distributionNetwork = "distribution network"
    case selectUser = "select user"
    case deleteUser = "delete user"

    case openHeartRate = "Open HeartRate"
    case closeHeartRate = "Close HeartRate"
    case openImpedance = "Open Impedance"
    case closeImpedance = "Close Impedance"
    case otaUser = "OTA-User Upgrade"
    case otaLocal = "OTA-Local Upgrade"
    case dataSyncLog = "Sync Log"
    
    case impedanceTestMode = "Impedance Test Mode"
    case openImpedanceTestMode = "Open Impedance Test Mode"
    case closeImpedanceTestMode = "Close Impedance Test Mode"
    
    case setTorreLanguage = "set Language"
    case getTorreLanguage = "get Language"
    
    case getRGBMode = "get RGBMode"
    case setRGBMode = "set RGBMode"
    case getUserMembers = "get UserMembers"

    case fetchUserInfo = "fetch UserInfo"
    case getUserInfoIsEdit = "get UserInfoIsEdit"
    case setUserInfoIsNotEdit = "set UserInfoIsNotEdit"
    case setUserInfoIsEdit = "set UserInfoIsEdit"


}

class DeviceTorreViewController: BaseViewController {

    var XM_Torre: PPBluetoothPeripheralTorre?
    

    var array = [menuType.checkBindState,menuType.deviceInfo,menuType.startMeasure,.selectUser,menuType.SyncTime,.wificonfigstatus,.distributionNetwork,.SyncUserList,.deleteUser,.ImpedanceSwitch, .openImpedance, .closeImpedance,.changeUnit,.HeartRateSwitch, .openHeartRate, .closeHeartRate,.clearDeviceData,.ScreenLuminance,.keepAlive, .otaUser, .otaLocal, .dataSyncLog, .impedanceTestMode, .openImpedanceTestMode, .closeImpedanceTestMode, .setTorreLanguage, .getTorreLanguage]
    
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
        self.XM_Torre?.codeStartMeasure({ status in
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop measurement command
        self.XM_Torre?.codeStopMeasure({ status in
        })
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
    
    func displayScaleModel(_ scaleModel:PPBluetoothScaleBaseModel, isLock:Bool) {
        
        let calculateWeightKg = Float(scaleModel.weight)/100
        
        var weightStr = calculateWeightKg.toCurrentUserString(accuracyType: Int(self.deviceModel.deviceAccuracyType.rawValue), unitType: Int(scaleModel.unit.rawValue),forWeight: true) + " \(Int(scaleModel.unit.rawValue).getUnitStr())"
        
        weightStr = isLock ? "weight lock:" + weightStr : "weight process:" + weightStr
        
        if (scaleModel.isHeartRating) {
            
            weightStr = weightStr + "\nMeasuring heart rate..."
        } else if (scaleModel.isFatting) {
            
            weightStr = weightStr + "\nMeasuring body fat..."
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
        
        
        if title == .SyncUserList{
            
        
            
            self.addBleCmd(ss: "dataSyncUserList")
            
            self.XM_Torre?.dataSyncUserList([user], withHandler: { [weak self] status in
                guard let `self` = self else {
                    return
                }
                
                self.addStatusCmd(ss: "\(status)")

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
        
        if title == .FetchHistory{
            self.addBleCmd(ss: "dataFetchHistoryData")
            
            self.XM_Torre?.dataFetchHistoryData(user, withHandler: { [weak self] models in
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

            self.addBleCmd(ss: "dataFindSurroundDevice")
            self.addBleCmd(ss: "hold on")
            
            self.XM_Torre?.dataFindSurroundDevice({ [weak self] wifiList in
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
                    self.XM_Torre?.dataConfigNetWork(wifiModel, domain: domain, withHandler: { [weak self] status, error in
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
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverFFF0Service")
        
        self.XM_Torre?.discoverFFF0Service()
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceTorreViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        
        self.addBleCmd(ss: "codeUpdateMTU")

        
        self.XM_Torre?.codeUpdateMTU({[weak self] statu in
            
            
            guard let `self` = self else {return}
            
            self.addStatusCmd(ss: "\(statu)")
            
            self.addBleCmd(ss: "codeStartMeasure")
            
            // Start measurement command, and send "stop measurement" command after measurement is completed.
            self.XM_Torre?.codeStartMeasure({ [weak self] status in
                
                guard let `self` = self else {return}
                
                self.addStatusCmd(ss: "\(statu)")
            })

            
            self.connectStateLbl.text = "connected"
            
            self.connectStateLbl.textColor = UIColor.green
            
            self.XM_IsConnect = true

        })

    }
    
}

extension DeviceTorreViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.weightLbl.text = String.init(format: "weight process:%0.2f", Float(model.weight) / 100.0)
        
        self.weightLbl.textColor = UIColor.red
        
    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.weightLbl.text = String.init(format: "weight lock:%0.2f", Float(model.weight) / 100.0)
        
        self.weightLbl.textColor = UIColor.green
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

