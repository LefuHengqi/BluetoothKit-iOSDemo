//
//  DeviceJambulViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/2
//  


import Foundation
import PPBluetoothKit
import PPCalculateKit

class DeviceJambulViewController: BaseViewController {
    var XM_Jambul : PPBluetoothPeripheralJambul?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let jambul = PPBluetoothPeripheralJambul.init(device: self.deviceModel)
        self.XM_Jambul = jambul
        self.XM_Jambul?.updateStateDelegate = self
        self.XM_Jambul?.scaleDataDelegate = self
        
        self.connectStateLbl.text = "Recevied advertisementData"
    }
    
    func displayScaleModel(_ scaleModel:PPBluetoothScaleBaseModel, advModel: PPBluetoothAdvDeviceModel, isLock:Bool) {
        
        let calculateWeightKg = Float(scaleModel.weight)/100
        
        var weightStr = calculateWeightKg.toCurrentUserString(accuracyType: Int(self.deviceModel.deviceAccuracyType.rawValue), unitType: Int(scaleModel.unit.rawValue),forWeight: true) + " \(Int(scaleModel.unit.rawValue).getUnitStr())"
        
        weightStr = isLock ? "weight lock:" + weightStr : "weight process:" + weightStr
        
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

            let fatModel = PPBodyFatModel(inputModel: inputModel)
            
            let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
            
            //Get the range of each body indicator
            let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
            let weightParam = detailModel.ppBodyParam_Weight
            print("weight-currentValue:\(weightParam.currentValue) range:\(weightParam.standardArray)  standardTitle:\(bodyDataJson[weightParam.standardTitle] ?? "") standSuggestion:\(bodyDataJson[weightParam.standSuggestion] ?? "") standeValuation:\(bodyDataJson[weightParam.standeValuation] ?? "")")
            //        print("data:\(detailModel.data)")
            
            
            let ss = CommonTool.getDesp(fatModel: fatModel, inputModel: inputModel)
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
        
        // 恢复设备的默认行为
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.XM_Jambul?.scaleDataDelegate = nil;
        self.XM_Jambul?.updateStateDelegate = nil;
        self.XM_Jambul?.stopSearch()
    }

}

extension DeviceJambulViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            
            self.addConsoleLog(ss: "centralManagerDidUpdate")
            self.addBleCmd(ss: "receivedDeviceData")
            
            self.XM_Jambul?.receivedDeviceData()
        }
    }
}


extension DeviceJambulViewController: PPBluetoothScaleDataDelegate {
    
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel: advModel, isLock: false)
        self.weightLbl.textColor = .red

    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
     
        self.displayScaleModel(model, advModel: advModel, isLock: true)
        self.weightLbl.textColor = .green

    }
}


extension DeviceJambulViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceJambulViewController"
    }
}

