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
    var advDevice:PPBluetoothAdvDeviceModel?
    var XM_ScaleHistoryList : Array<PPBluetoothScaleBaseModel>? //同步历史数据
    var XM_HistoryComplete:((_ list:[PPBluetoothScaleBaseModel])->(Void))?

    var array = [DeviceMenuType.startMeasure, DeviceMenuType.SyncTime, DeviceMenuType.FetchHistory, DeviceMenuType.changeUnit]
    
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
        
        weightStr = isLock ? Localization.string("weight_lock") + weightStr : Localization.string("weight_process") + weightStr
        
        // Measurement completed
        if scaleModel.isEnd {
            
            
            // Calculate body data (Four electrodes)
            let inputModel = PPCalculateInputModel()
            inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
            inputModel.isAthleteMode = false
            inputModel.isPregnantMode = false
            inputModel.height = 160
            inputModel.age = 20
            inputModel.gender = .female
            inputModel.deviceCalcuteType = advModel.deviceCalcuteType
            inputModel.weight = CGFloat(calculateWeightKg)
            inputModel.impedance = scaleModel.impedance
            inputModel.impedance100EnCode = scaleModel.impedance100EnCode
            inputModel.deviceMac = advModel.deviceMac
            inputModel.heartRate = scaleModel.heartRate
            inputModel.footLen = scaleModel.footLen
            inputModel.bodyAgeMethod = PPBodyAgeMethod(rawValue: UInt(advModel.getBodyAgeTypeCode())) ?? .default

            
            let fatModel = PPBodyFatModel(inputModel: inputModel)

            
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

}


extension DeviceCoconutViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = array[indexPath.row]
        
        
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
        
        let title = array[indexPath.row]

        
        if !self.XM_IsConnect{
            
            self.addStatusCmd(ss: "device disconnect")
            
            self.view.makeToast(Localization.string("disconnect"))
            
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
            
            let funcType = self.deviceModel.deviceFuncType
            if !PPBluetoothManager.hasHistoryFunc(funcType){
                
                self.addStatusCmd(ss: "This device does not support the historical data feature.")
                
                return
            }
            
            
            let vc = DeviceHistoryDataViewController()
            vc.deviceModel = self.advDevice
            
            // 获取用户历史数据
            // Fetch user history data
            vc.onFetchLeftHistory = { [weak self] in
                guard let `self` = self else { return }

                vc.view.makeToastActivity(.center)
                
                self.XM_ScaleHistoryList = []
                self.XM_HistoryComplete = {[weak self] models in
                    guard let `self` = self else { return }
                    
                    vc.view.hideToastActivity()
                    
                    if models.count < 1 {
                        vc.view.makeToast(Localization.string("Historical_empty"))
                    }
                    
                    vc.setHistory(models, type: .left)
                }
                
                self.addBleCmd(ss: "fetchDeviceHistoryData")
                self.XM_Coconut?.fetchDeviceHistoryData()
            }
            
            // 删除设备中历史数据
            // Delete historical data from the device
            vc.onFetchRightHistory = { [weak self] in
                guard let `self` = self else { return }
                
                self.addBleCmd(ss: "deleteDeviceHistoryData")

                self.XM_Coconut?.deleteDeviceHistoryData()
                
                vc.view.makeToast(Localization.string("Command_sent"))
                
            }
            
            self.navigationController?.pushViewController(vc, animated: true)

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
            
            self.advDevice = deviceModel

        }
        


    }
    
}
extension DeviceCoconutViewController: PPBluetoothCMDDataDelegate{
    
    func syncDeviceHistorySuccess() { //同步历史数据成功
        
        if let models = self.XM_ScaleHistoryList{
            
            models.forEach({ model in
                
                self.addStatusCmd(ss: "histroty---weight:\(model.weight)")
                
            })
            
        }
        
        self.XM_HistoryComplete?(self.XM_ScaleHistoryList ?? [])
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
        
        self.connectStateLbl.text = Localization.string("disconnect")
        
        self.connectStateLbl.textColor = UIColor.red
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
}

extension DeviceCoconutViewController: PPBluetoothServiceDelegate{
    
    func discoverDeviceInfoServiceSuccess(_ device: PPBluetooth180ADeviceModel!) {
        
        
    }
    
    func discoverFFF0ServiceSuccess() {
        
        self.XM_Coconut?.scaleDataDelegate = self
        
        self.addBleCmd(ss: "discoverFFF0ServiceSuccess")
        
        // Sync Time
        // 同步时间
        
        self.addBleCmd(ss: "codeSyncTime")
        self.XM_Coconut?.syncDeviceTime()

        self.XM_IsConnect = true

        self.connectStateLbl.text = Localization.string("connected")
        self.connectStateLbl.textColor = UIColor.green



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

