//
//  DeviceAppleViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/10.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

class DeviceAppleViewController: BaseViewController {

    
    var XM_Apple : PPBluetoothPeripheralApple?
    var XM_ScaleHistoryList : Array<PPBluetoothScaleBaseModel>? //同步历史数据
    var scaleCoconutViewController:ScaleCoconutViewController?

    
    var array = [DeviceMenuType.startMeasure, DeviceMenuType.SyncTime, DeviceMenuType.FetchHistory, DeviceMenuType.DeleteHistoryData, DeviceMenuType.changeUnit,DeviceMenuType.distributionNetwork,DeviceMenuType.queryWifiConfig,DeviceMenuType.restoreFactory,DeviceMenuType.queryDeviceTime,DeviceMenuType.queryDNS, DeviceMenuType.TestOTA, DeviceMenuType.UserOTA]
    
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

        // Do any additional setup after loading the view.
    }
    
    
    func setupBleManager(){
        
        self.scaleManager = PPBluetoothConnectManager()
        
        self.scaleManager.updateStateDelegate = self;
        
        self.scaleManager.surroundDeviceDelegate = self;
    }
    
    
    func enterWifiConfigClick() {
        
        let alertController = UIAlertController(title: "wifi config", message: "", preferredStyle: .alert)
        
        // 添加三个输入框
        alertController.addTextField { (textField) in
            textField.placeholder = "SSID"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "PASSWORD"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "DOMAIN"
            textField.text = "http://nat.lefuenergy.com:10082"
        }

        // 添加取消和确定按钮
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "ok", style: .default) {[weak self] (action) in
            
            guard let `self` = self else { return }
            
            // 获取输入框的值
            if let textField1 = alertController.textFields?[0], let textField2 = alertController.textFields?[1], let textField3 = alertController.textFields?[2] {
                let value1 = textField1.text ?? ""
                let value2 = textField2.text ?? ""
                let value3 = textField3.text ?? ""
                
                self.addStatusCmd(ss: "SSID:\(value1)")
                self.addStatusCmd(ss: "PASSWORD:\(value2)")
                self.addStatusCmd(ss: "DOMAIN:\(value3)")
                
                let wifiConfig = PPWifiInfoModel()
                wifiConfig.ssid = value1
                wifiConfig.password = value2
                
                self.addStatusCmd(ss: "hold on")

                
                self.addBleCmd(ss: "changeDNS")
                self.XM_Apple?.changeDNS(value3,withHandler: {[weak self] status in
                    
                    guard let `self` = self else {
                        return
                    }
                    
                    self.addStatusCmd(ss: "\(status)")
                    
                    self.addBleCmd(ss: "configNetWork")

                    self.XM_Apple?.configNetWork(withSSID: value1, password: value2, handler: { [weak self] (sn, state) in
                        self?.addStatusCmd(ss: "state:\(state) sn:\(sn)")
                    })
                })
                
               

        

            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        // 显示 UIAlertController
        present(alertController, animated: true, completion: nil)
        
        
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
                                          impedance100EnCode: scaleModel.impedance100EnCode,
                                          footLen: scaleModel.footLen
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

    deinit {
        
        self.scaleManager.stopSearch()
        
        if let peripheral = self.XM_Apple?.peripheral{
            
            self.scaleManager.disconnect(peripheral)
        }
        
    }

}

extension DeviceAppleViewController:PPBluetoothUpdateStateDelegate{
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        
        self.addConsoleLog(ss: "centralManagerDidUpdate")
        
        self.consoleView.text = self.conslogStr
        
        self.scaleManager.searchSurroundDevice()
    }
    

    
    
    
}

extension DeviceAppleViewController:PPBluetoothSurroundDeviceDelegate{
    

    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        guard let deviceModel = self.deviceModel else {return}

        
        if(device.deviceMac == self.deviceModel.deviceMac){
            
            
            self.addConsoleLog(ss: "centralManagerDidFoundSurroundDevice mac:\(device.deviceMac)")

            
            self.scaleManager.stopSearch()
            
            
            self.scaleManager.connectDelegate = self
            self.scaleManager.connect(peripheral, withDevice: device)
            
            self.XM_Apple = PPBluetoothPeripheralApple(peripheral: peripheral, andDevice: device)
            self.XM_Apple?.serviceDelegate = self
            self.XM_Apple?.cmdDelegate = self
//            self.XM_Coconut?.scaleDataDelegate = self

        }
        


    }
    
}

extension DeviceAppleViewController:PPBluetoothConnectDelegate{
    
    
    func centralManagerDidConnect() {
                
        
        self.addConsoleLog(ss: "centralManagerDidConnect")

        
        self.addBleCmd(ss: "discoverDeviceInfoService")

        self.XM_Apple?.discoverDeviceInfoService({[weak self] model in
            
            guard let `self` = self else {return}
            self.addBleCmd(ss: "discoverFFF0Service")

            self.XM_Apple?.discoverFFF0Service()

        })
        
    }
    
    func centralManagerDidDisconnect() {
        
        self.XM_IsConnect = false
        
        self.connectStateLbl.text = "disconnect"
        
        self.connectStateLbl.textColor = UIColor.red
    }
    
    
}

extension DeviceAppleViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        self.XM_Apple?.scaleDataDelegate = self

        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")
        self.XM_IsConnect = true

        self.connectStateLbl.text = "connected"
        self.connectStateLbl.textColor = UIColor.green

    }
    
}


extension DeviceAppleViewController: PPBluetoothCMDDataDelegate{
    
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

extension DeviceAppleViewController:PPBluetoothScaleDataDelegate{
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: false)
        
        self.weightLbl.textColor = UIColor.red
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = false

    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        displayScaleModel(model, advModel: advModel, isLock: true)
        
        self.weightLbl.textColor = UIColor.green
        
        self.scaleCoconutViewController?.XM_PPBluetoothScaleBaseModel = model
        self.scaleCoconutViewController?.complete = true

    }
    
    
    func monitorHistoryData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.XM_ScaleHistoryList?.append(model)
    }
}

extension DeviceAppleViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceAppleViewController"
    }



}



extension DeviceAppleViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        return CGSizeMake((UIScreen.main.bounds.size.width - 40) / 3,50)
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

//            self.scaleCoconutViewController?.XM_Coconut = self.XM_Coconut
//            self.XM_Coconut.

            self.navigationController?.pushViewController(self.scaleCoconutViewController!, animated: true)

            return

        }

        if title == .SyncTime{

            self.addBleCmd(ss: "codeSyncTime")

            self.XM_Apple?.syncDeviceTime(handler: { status in
            })

        }


        if title == .FetchHistory{
            self.addBleCmd(ss: "dataFetchHistoryData")
            self.XM_ScaleHistoryList = []
            self.XM_Apple?.fetchDeviceHistoryData()

        }
        if title == .DeleteHistoryData{
            self.addBleCmd(ss: "deleteHistoryData")
            self.XM_Apple?.deleteDeviceHistoryData(handler: { status in
            })
        }
        
        if title == .changeUnit{
            self.addBleCmd(ss: "codeChange")
            user.unit = PPDeviceUnit.unitLB
            self.XM_Apple?.syncDeviceSetting(user)
                
        }
        
        if title == .distributionNetwork{
            
            self.enterWifiConfigClick()
        }
        
        if title == .queryWifiConfig {
            self.addBleCmd(ss: "queryWifiConfig")
            self.XM_Apple?.queryWifiConfig(handler: {[weak self] wifiInfo in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: "ssid:\(wifiInfo?.ssid ?? "")")
                self.addConsoleLog(ss: "password:\(wifiInfo?.password ?? "")")
            })
        }
        
        if title == .restoreFactory {
            self.addBleCmd(ss: "restoreFactory")
            
            self.XM_Apple?.restoreFactory {
                
            }
            
        }
        
        if title == .queryDeviceTime {
            self.addBleCmd(ss: "queryDeviceTime")
            
            self.XM_Apple?.queryDeviceTime({[weak self] timeStr in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: timeStr)
            })
        }
        
        if title == .queryDNS {
            self.addBleCmd(ss: "queryDNS")
            
            self.XM_Apple?.queryDNS(handler: { [weak self] dns in
                guard let `self` = self else {
                    return
                }
                
                self.addConsoleLog(ss: dns)
            })
        }
        
        
        // Develop dedicated OTA for use in special circumstances
        if title == .TestOTA {

            self.addStatusCmd(ss: "queryWifiConfig")
            
            // Query Wi-Fi distribution network
            self.XM_Apple?.queryWifiConfig(handler: {[weak self] wifiInfo in
                guard let `self` = self else {
                    return
                }

                if (wifiInfo?.ssid.count ?? 0) < 1 || (wifiInfo?.password.count ?? 0) < 1 {
                    self.addConsoleLog(ss: "Need to configure the network first")
                    return
                }
                
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.view.isUserInteractionEnabled = true
                }
                
                self.addStatusCmd(ss: "startUserOTA")
                self.addStatusCmd(ss: "Upgrade command has been sent, please wait")
                
                // OTA needs to complete Wi-Fi network configuration
                self.XM_Apple?.startTestOTA()
                
            })

        }
        
        if title == .UserOTA {

            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.view.isUserInteractionEnabled = true
            }
            
            self.addStatusCmd(ss: "startUserOTA")
            
            self.XM_Apple?.startUserOTA(handler: {[weak self] status in
                guard let `self` = self else {
                    return
                }
                
                // 0 Successful reception, start OTA; 1 Failure to receive, no SSID configured, exit OTA; 2 Low battery, exit OTA; 3 Charging, exit OTA
                self.addStatusCmd(ss: "status:\(status)")
                
            })

        }

    }
}
